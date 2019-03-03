--подсчитайте число элементов в созданной коллекции tags в bd movies
print("tags count: ", db.tags.count());

--подсчитайте число фильмов с конкретным тегом - woman
print("woman tags count: ", db.tags.count({'name': 'woman'}));

--используя группировку данных ($groupby) вывести top-3 самых распространённых тегов
printjson(
    db.tags.aggregate([
        {$group: {_id: "$name", tag_count: { $sum: 1 }}},
        {$sort: {"tag_count" : -1}},
        {$limit: 3}
        ])['_batch']
);
