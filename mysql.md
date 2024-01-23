## aynı olan değerleri bulma
```mysql
select adi,count(adi) from fonlar group by adi having count(adi)>1;
```

## aynı olanları silme
```mysql
delete t1 from fonlar t1 inner join fonlar t2 where t1.id<t2.id and t1.adi=t2.adi;
```

## tablonun içeriğini silen ve id(primary key) değerini sıfırlayan
```mysql
truncate fonlar;
```
