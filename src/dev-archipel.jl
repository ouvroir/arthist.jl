using Dates;
using DataFrames;
using JSON;
using JSONTables;
using Plots;
using TextAnalysis;
using Languages;

# Travailler sur le fichier puis le fermer automatiquement
open("src/data/archipel.json") do file
    # Transformer en DataFrame
    jtable = jsontable(file)
    global df1 = DataFrame(jtable)
end

# Lister les noms des colonnes du DataFrame
propertynames(df1)

df1[!, 12:14]

open("src/data/archipel.json") do file
    # Transformer en DataFrame
    json = JSON.parse(file)
    global df = DataFrame(json)
end

# Lister les noms des colonnes du DataFrame
names(df)

# Sélectionner les colonnes qui nous intéressent
df[:, [:creators, :date, :uri, :title, :abstract, :keywords]] # ici `:` ou `!` affichent toutes les lignes

# Créer un nouveau DataFrame avec les colonnes sélectionnées
select!(df, [:creators, :date, :uri, :title, :abstract, :keywords]) # ici select! modifie le DataFrame

size(df)

df[1, :creators][1]

# Restructuration des colonnes `:creators` et `:date`
select!(df, :creators => ByRow(x -> x[1]["name"]["family"] * ", " * x[1]["name"]["given"]) => :creators, :date => ByRow(x -> Date(x)) => :date, :uri, :title, :abstract, :keywords)

histogram(df.date, bins=25, label="Thèses", xlabel="Date", ylabel="Nb", title="Thèses soutenues à l’UQAM en Histoire de l’art")

# Corpus et documents

crps = Corpus(
    df[:, :abstract] |> x -> StringDocument.(x)
)

languages!(crps, Languages.French())
titles!(crps, df[:, :title])
authors!(crps, df[:, :creators])

crps[1]
crps[2]

prepare!(crps, strip_punctuation | strip_case | strip_articles | strip_prepositions | strip_pronouns |strip_stopwords | strip_non_letters | strip_whitespace)

lexicon(crps)
lexicon_size(crps)

frequent_terms(crps)
lexical_frequency(crps, "art")
lexical_frequency(crps, "architecture")

tokens(crps[1])
ngrams(crps[1])
ngrams(crps[1], 2)

update_lexicon!(crps)
dtm = DocumentTermMatrix(crps)
tf(dtm)

tf_idf(dtm)


# TF-IDF
## Exploration de la fréquence des mots

crp1 = Corpus([
    StringDocument(df[1, :abstract]),
    StringDocument(df[2, :abstract]) 
    ])
update_lexicon!(crp1)
dtm = DocumentTermMatrix(crp1)
tf(dtm)
crp1[1]


# Preprocessing

using TextAnalysis;

function prepare_document(content::String)
    contentdoc = StringDocument(content)
    prepare!(contentdoc, strip_punctuation | strip_whitespace | strip_case)
    return contentdoc
end

# todo : ajouter une colonne `:abstract_prep` avec les abstracts préparés df2 = insertcols(df, :abstract, :abstract_prep => ByRow(x -> prepare_document(x)))

preprocessed = df[1, :abstract] |> prepare_document


# 2.3 Converting tokens into IDs

all_words = sort(collect(tokens(preprocessed)))
vocab_size = length(all_words)


# Listing 2.2 Creating a vocabulary

vocab = Dict(word => idx for (idx, word) in enumerate(all_words))
sort!(collect(vocab), by=last, rev=true)


crps = Corpus(df[1:100, :abstract] |> x -> prepare_document.(x))
update_lexicon!(crps)

m = DocumentTermMatrix(crps)


# Visualiser les mots les plus fréquents sous la forme d’un nuage de mots

using WordCloud ;

wc = wordcloud(text(preprocessed), angles = (0, 90), density = 0.7)

# Pour générer une image avec le wordcloud 
# generate!(wc) 
# paint(wc, "wordcloud.svg")