# Write your package code here.
using DataFrames;
using JSON;
using JSONTables;

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

# Restructuration de la colonne `:creators``
select!(df, :creators => ByRow(x -> x[1]["name"]["family"] * ", " * x[1]["name"]["given"]) => :creators, :date, :uri, :title, :abstract, :keywords)

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

# all_words = sorted(set(preprocessed))
# vocab_size = len(all_words)
# print(vocab_size)

all_words = sort(collect(tokens(preprocessed)))
vocab_size = length(all_words)
println("Taille du vocabulaire : $vocab_size")

# Listing 2.2 Creating a vocabulary

vocab = Dict(word => idx for (idx, word) in enumerate(all_words))
sort!(collect(vocab), by=last, rev=true)

using WordCloud ;

wc = wordcloud(text(preprocessed))
# generate! paint(wc, "wordcloud.svg")

crps = Corpus(df[1:100, :abstract] |> x -> prepare_document.(x))

update_lexicon!(crps)

m = DocumentTermMatrix(crps)

