from flask import Flask, request, jsonify
import stanza
import pyarabic.araby as araby
import math

app = Flask(__name__)

@app.route('/process', methods=['POST'])
def process():
    # Retrieve the Arabic text from the request
    arabic_text = request.json['arabic_text']

    # Initialize the Arabic part-of-speech tagger and NER using Stanza
    nlp = stanza.Pipeline("ar", processors="tokenize,pos,ner")

    # Tokenize the input text into sentences using pyarabic.araby
    sentences = araby.sentence_tokenize(arabic_text)

    # Calculate the square root of the number of sentences to determine the number of sections
    num_sections = int(math.sqrt(len(sentences)))

    # Calculate the number of sentences in each section
    sentences_per_section = len(sentences) // num_sections
    remaining_sentences = len(sentences) % num_sections

    # Initialize variables to store sections and their sentences
    sections = [[] for _ in range(num_sections)]

    # Distribute the sentences into sections
    section_start = 0
    for i in range(num_sections):
        section_end = section_start + sentences_per_section
        if i < remaining_sentences:
            section_end += 1
        sections[i] = sentences[section_start:section_end]
        section_start = section_end

    # Define a function to calculate the score for a sentence
    def calculate_sentence_score(sentence):
        # Tokenize the sentence into words using pyarabic.araby
        words = araby.tokenize(sentence)

        # Process the sentence with Stanza for POS tagging and NER
        doc = nlp(sentence)

        # Initialize a score
        score = 0

        # Define a list of meaningful POS tags (e.g., nouns, verbs)
        meaningful_pos_tags = ['NOUN', 'VERB', 'ADJ', 'ADV']

        # Calculate the score based on POS tags
        for sentence in doc.sentences:
            for word in sentence.words:
                if word.upos in meaningful_pos_tags:
                    score += 1

        # Retrieve NER annotations and count meaningful NER entities
        ner_annotations = [ent.type for sent in doc.sentences for ent in sent.ents]
        meaningful_ner_labels = ['PERSON', 'ORG', 'GPE']

        for ner_label in ner_annotations:
            if ner_label in meaningful_ner_labels:
                score += 1

        return score

    # Initialize a list to store the highest-scoring sentence from each section
    highest_scoring_sentences = []

    # Calculate scores for each sentence and find the highest-scoring sentence in each section
    for i, section in enumerate(sections, 1):
        print(f"Section {i}:")
        section_scores = [(sentence, calculate_sentence_score(sentence)) for sentence in section]
        section_scores.sort(key=lambda x: x[1], reverse=True)
        highest_scoring_sentence = section_scores[0][0]
        highest_scoring_sentences.append(highest_scoring_sentence)
        for j, (sentence, score) in enumerate(section_scores, 1):
            print(f"Sentence {j}:")
            print(sentence)
            print(f"Score: {score}")
        print(f"Highest Scoring Sentence in Section {i}:")
        print(highest_scoring_sentence)
        print("\n")

    # Print the highest-scoring sentences from all sections
    print("Highest Scoring Sentences from All Sections:")
    for i, sentence in enumerate(highest_scoring_sentences, 1):
        print(f"Section {i}:")
        print(sentence)

    # Return the highest-scoring sentences
    return jsonify({'highest_scoring_sentences': highest_scoring_sentences})

if __name__ == '__main__':
    app.run(host='192.168.100.219', debug=True)