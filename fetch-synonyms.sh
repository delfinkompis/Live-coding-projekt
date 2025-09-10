curl -sX POST \
     -H "Content-Type: application/json" \
     -d '{
    "query": "query Word($word: String!, $dictionaries: [Dictionary!]!) { word(word: $word, dictionaries: $dictionaries) { articles { relationships { ... on SynonymArticleRelationship { article { lemmas { lemma } } } ... on SeeAlsoArticleRelationship { article { lemmas { lemma } } } ... on RelatedArticleRelationship { article { lemmas { lemma } } } } } } }",
    "variables": {
      "word": "'"$1"'",
      "dictionaries": ["Bokmaalsordboka"]
    }
  }' \
  http://127.0.0.1:3000 | grep -hoP "lemma\":\"\K[^\"]+"
