from flask import Flask, request, jsonify
import stanza
from pyarabic.araby import sentence_tokenize, strip_tashkeel
import nltk
from nltk.stem.isri import ISRIStemmer
from transformers import pipeline
from collections import Counter
from nltk.tokenize import word_tokenize
import numpy as np

# Initialize the Flask application
app = Flask(__name__)

# Initialize ISRIStemmer for Arabic text
stemmer = ISRIStemmer()

# Download NLTK data for tokenization
nltk.download('punkt')

# Initialize Stanza pipeline for Arabic text processing
nlp = stanza.Pipeline(lang='ar', processors='tokenize,mwt,pos,lemma,depparse,ner')


# Define the Flask route for TOPSIS calculation
@app.route('/calculate_topsis', methods=['POST'])
def calculate_topsis():

    # Function to stem a list of tokens
    def stem_tokens(tokens):
        return [stemmer.stem(token) for token in tokens]

    # Function to calculate word probabilities in the story
    def calculate_word_probability(story):
        # Tokenize words in the story
        words = word_tokenize(story)

        # Stem the words
        stemmed_words = stem_tokens(words)

        # Count the frequency of each stemmed word
        word_counts = Counter(stemmed_words)

        # Calculate the total number of stemmed words
        total_words = len(stemmed_words)

        # Calculate word probabilities as a dictionary
        word_probabilities = {word: count / total_words for word, count in word_counts.items()}

        return word_probabilities

    # Function to calculate noun score for a clause
    def calculate_noun_score(clause, word_probabilities, nlp):
        # Process the clause using Stanza NLP
        clause_doc = nlp(clause)

        # Extract nouns (words with part-of-speech starting with 'N')
        nouns = [word.text for sentence in clause_doc.sentences for word in sentence.words if word.upos.startswith('N')]

        # Stem the nouns
        stemmed_nouns = stem_tokens(nouns)

        # If there are no nouns or stemmed nouns, return 0 score
        if len(nouns) == 0:
            return nouns, 0
        if len(stemmed_nouns) == 0:
            return stemmed_nouns, 0

        # Calculate noun score as the average of word probabilities for stemmed nouns
        noun_score = sum(word_probabilities.get(noun, 0) for noun in stemmed_nouns) / len(stemmed_nouns)

        return stemmed_nouns, noun_score

    # Function to calculate title word score for a clause
    def calculate_title_word_score(clause, title, nlp):
        # Process the title and clause using Stanza NLP
        title_doc = nlp(title)
        clause_doc = nlp(clause)

        # Extract title tokens with part-of-speech ['NOUN', 'X', 'ADJ']
        title_tokens = [word.text for sent in title_doc.sentences for word in sent.words if word.upos in ['NOUN', 'X', 'ADJ']]

        # Create a set of stemmed title tokens
        title_stems = set(stem_tokens(title_tokens))

        # Extract clause tokens with part-of-speech ['NOUN', 'X', 'ADJ']
        clause_tokens = [word.text for sent in clause_doc.sentences for word in sent.words if word.upos in ['NOUN', 'X', 'ADJ']]

        # Create a set of stemmed clause tokens
        clause_stems = set(stem_tokens(clause_tokens))

        # If any stemmed clause token is in the set of stemmed title tokens, return 1, otherwise 0
        return 1 if any(stem in title_stems for stem in clause_stems) else 0

    # Function to tokenize sentences using Stanza NLP
    def stanza_sentence_tokenize(text):
        # Process the text using Stanza NLP
        doc = nlp(text)
        # Extract sentence texts
        sentences = [sentence.text for sentence in doc.sentences]

        return sentences

    # Function to calculate dissimilarity matrix between clauses in a story
    def calculate_dissimilarity_matrix(story):
        # Tokenize the story into clauses
        clauses = sentence_tokenize(story)

        # Stem the tokens in each clause
        stemmed_clauses = [stem_tokens(clause.split()) for clause in clauses]

        # Get the number of clauses
        n = len(stemmed_clauses)

        # Initialize a dissimilarity matrix with zeros
        dissimilarity_matrix = [[0 for _ in range(n)] for _ in range(n)]

        # Calculate dissimilarity scores between all pairs of clauses
        for i in range(n):
            for j in range(n):
                # Check if the clauses are different and not empty
                if i != j and clauses[i].strip() and clauses[j].strip():
                    set_i = set(stemmed_clauses[i])
                    set_j = set(stemmed_clauses[j])

                    # Calculate unique tokens in each clause
                    unique_tokens_i = set_i - set_j
                    unique_tokens_j = set_j - set_i

                    # Calculate total unique tokens and total tokens in both clauses
                    total_unique_tokens = len(unique_tokens_i) + len(unique_tokens_j)
                    total_tokens = len(set_i.union(set_j))

                    # Calculate the dissimilarity score for this pair of clauses
                    if total_tokens == 0:
                        dissimilarity_matrix[i][j] = 0
                    else:
                        dissimilarity_matrix[i][j] = total_unique_tokens / total_tokens

        return dissimilarity_matrix

    # Function to calculate normalized clause lengths
    def calculate_normalized_clause_length(story, clauses):
        # Tokenize all clauses in the story
        all_clauses = sentence_tokenize(story)

        # Calculate the lengths of all clauses
        all_clause_lengths = [len(clause.split()) for clause in all_clauses]

        # Find the maximum clause length
        max_clause_length = max(all_clause_lengths, default=1)

        # Calculate normalized lengths for the input clauses
        normalized_lengths = [len(clause.split()) / max_clause_length for clause in clauses]

        return normalized_lengths

    # Function to calculate part-of-speech (POS) scores for clauses
    def calculate_pos_scores(clauses, nlp):
        pos_scores = []

        for clause in clauses:
            if clause.strip():
                # Process the clause using Stanza NLP
                clause_doc = nlp(clause)

                # Define relevant POS tags (ADJ and VERB)
                relevant_pos_tags = {'ADJ', 'VERB'}

                # Count the number of relevant POS tags in the clause
                pos_count = sum(word.upos in relevant_pos_tags for sentence in clause_doc.sentences for word in sentence.words)

                pos_scores.append(pos_count)
            else:
                pos_scores.append(0)

        return pos_scores

    # Function to process and score clauses in sentences
    def process_and_score_clauses(sentences, title, nlp, sentiment_model, word_probabilities, title_stems, story):
        scores_matrix = []  # Initialize an empty matrix to store scores for each clause
        clause_scores = {}  # Initialize an empty dictionary to store scores for each clause
        for sentence in sentences:
            clauses = sentence_tokenize(sentence)  # Tokenize the sentence into clauses
            dissimilarity_matrix = calculate_dissimilarity_matrix(story)  # Calculate dissimilarity matrix for the story

            n = len(dissimilarity_matrix)  # Get the number of clauses in the story
            raw_sums = [sum(dissimilarity_matrix[i]) for i in range(n)]  # Calculate raw sums of dissimilarity scores
            min_sum = min(raw_sums)  # Find the minimum raw sum
            max_sum = max(raw_sums)  # Find the maximum raw sum
            range_sum = max_sum - min_sum  # Calculate the range of raw sums
            normalized_sums = [(raw_sum - min_sum) / range_sum if range_sum > 0 else 0 for raw_sum in raw_sums]  # Normalize raw sums

            pos_scores = calculate_pos_scores(clauses, nlp)  # Calculate part-of-speech (POS) scores for clauses
            normalized_lengths = calculate_normalized_clause_length(story, clauses)  # Calculate normalized clause lengths

            for i, clause in enumerate(clauses):
                if clause.strip():
                    clause_doc = nlp(clause)  # Process the clause using Stanza NLP
                    clause_tokens = [word.text for sent in clause_doc.sentences for word in sent.words]
                    clause_stems = stem_tokens(clause_tokens)  # Stem the tokens in the clause
                    title_word_score = calculate_title_word_score(clause, title, nlp)  # Calculate title word score for the clause

                    sentiment_result = sentiment_model(clause)[0]  # Get sentiment analysis results for the clause
                    sentiment_score = 0
                    sentiment_label = sentiment_result['label']
                    if sentiment_label != 'neutral':
                        sentiment_score = sentiment_result['score']  # Assign a sentiment score based on the sentiment label

                    nouns, noun_score = calculate_noun_score(clause, word_probabilities, nlp)  # Calculate noun scores for the clause

                    dissimilarity_score = normalized_sums[i]  # Get the dissimilarity score for the clause
                    pos_score = pos_scores[i]  # Get the POS score for the clause
                    normalized_length = normalized_lengths[i]  # Get the normalized clause length

                    overall_score = title_word_score + sentiment_score + noun_score + dissimilarity_score + pos_score + normalized_length  # Calculate the overall score for the clause

                    clause_scores[clause] = overall_score  # Store the overall score in the dictionary
                    scores_matrix.append([sentiment_score, title_word_score, noun_score, dissimilarity_score, pos_score, normalized_length])  # Append scores to the matrix

        return scores_matrix, clause_scores  # Return the scores matrix and clause scores as results

    # Function to calculate clause scores for Arabic text
    def calculate_clause_scores_arabic(story, title):
        title_doc = nlp(title)  # Process the title using Stanza NLP
        title_tokens = [word.text for sent in title_doc.sentences for word in sent.words]
        title_stems = set(stem_tokens(title_tokens))  # Stem the tokens in the title

        word_probabilities = calculate_word_probability(story)  # Calculate word probabilities for the story

        sentiment_model = pipeline('sentiment-analysis', model='CAMeL-Lab/bert-base-arabic-camelbert-mix-sentiment')  # Load a sentiment analysis model for Arabic

        sentences = stanza_sentence_tokenize(story)  # Tokenize the story into sentences

        # Process and score clauses in the story
        scores_matrix, clause_scores = process_and_score_clauses(sentences, title, nlp, sentiment_model, word_probabilities, title_stems, story)

        return scores_matrix, clause_scores  # Return the scores matrix and clause scores as results

    # Function to normalize a matrix
    def normalize_matrix(matrix):
        epsilon = 1e-10  # A small constant to prevent division by zero
        denominators = np.sqrt(np.sum(matrix**2, axis=0))  # Calculate the denominator for normalization
        normalized_matrix = np.zeros_like(matrix)  # Initialize an empty matrix with the same shape as the input matrix

        for i in range(matrix.shape[1]):
            normalized_matrix[:, i] = matrix[:, i] / (denominators[i] + epsilon)  # Normalize each column of the matrix

        return normalized_matrix  # Return the normalized matrix

    # Function to calculate the ideal and negative-ideal solutions for a normalized matrix
    def calculate_ideal_negative_ideal(normalized_matrix):
        positive_ideal_solution = np.max(normalized_matrix, axis=0)  # Calculate the positive ideal solution
        negative_ideal_solution = np.min(normalized_matrix, axis=0)  # Calculate the negative ideal solution

        return positive_ideal_solution, negative_ideal_solution  # Return the positive and negative ideal solutions

    # Calculate separation measures for each alternative
    def calculate_separation_measures(normalized_matrix, positive_ideal_solution, negative_ideal_solution):
        positive_separation = np.sqrt(np.sum((normalized_matrix - positive_ideal_solution)**2 , axis=1))
        negative_separation = np.sqrt(np.sum((normalized_matrix - negative_ideal_solution)**2 , axis=1))

        return positive_separation, negative_separation

    # Calculate relative closeness to the ideal solution
    def calculate_relative_closeness(positive_separation, negative_separation):
        relative_closeness = negative_separation / (positive_separation + negative_separation)

        print(f"relative_closeness :\n {relative_closeness} \n")

        return relative_closeness

    # Perform TOPSIS ranking
    def topsis_ranking(decision_matrix, clause_scores):
        # Normalize the decision matrix
        normalized_matrix = normalize_matrix(decision_matrix)

        # Apply weights to the criteria
        # 2/9 to the most important : noun score,dissimilarity_score, pos_score
        weights = np.array([1/9, 1/9, 2/9, 2/9, 2/9, 1/9])  # Adjust these weights as needed
        weighted_matrix = normalized_matrix * weights

        # Calculate ideal and negative-ideal solutions
        positive_ideal_solution, negative_ideal_solution = calculate_ideal_negative_ideal(weighted_matrix)

        # Calculate separation measures
        positive_separation, negative_separation = calculate_separation_measures(weighted_matrix, positive_ideal_solution, negative_ideal_solution)

        # Calculate relative closeness
        relative_closeness = calculate_relative_closeness(positive_separation, negative_separation)

        # Convert relative_closeness to a list
        relative_closeness_list = np.array(relative_closeness).tolist()

        # Map relative closeness to clauses
        topsis_scores = {}
        for i, clause in enumerate(clause_scores.keys()):
            topsis_scores[clause] = relative_closeness_list[i]

        return topsis_scores

    # Get the JSON data from the HTTP request
    data = request.get_json()

    # Extract the 'story' and 'title' values from the JSON data
    story = data['story']
    title = data['title']

    # Remove tashkeel (diacritics) from the 'story' and 'title'
    story = strip_tashkeel(story)
    title = strip_tashkeel(title)

    # Print the 'story' after removing tashkeel (for debugging)
    print(story)

    # Calculate clause scores for the Arabic 'story' and 'title'
    scores_matrix, clause_scores = calculate_clause_scores_arabic(story, title)

    # Perform TOPSIS ranking using the scores matrix and clause scores
    topsis_scores = topsis_ranking(np.array(scores_matrix), clause_scores)

    # Create a list of dictionaries, each containing 'clause' and 'score' keys
    topsis_scores_list = [{'clause': clause, 'score': score} for clause, score in topsis_scores.items()]

    # Return the list of TOPSIS scores as JSON response
    return jsonify(topsis_scores_list)


if __name__ == '__main__':
    app.run(host='192.168.100.161', debug=True)
