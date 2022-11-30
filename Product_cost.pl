item_value('Chair', 50).
item_value('Table', 100).
item_value('Plant', 75).

shopping_cart('Max', ['Chair', 'Chair', 'Table']).
shopping_cart('Sam', ['Plant', 'Table']).

total_sum(Person, Sum) :-
    shopping_cart(Person, ItemList),
    maplist(item_value, ItemList, CostList),
    foldl(plus, CostList, 0, Sum).
