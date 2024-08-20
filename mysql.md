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
## wordpress  Uncaught mysqli_sql_exception: Table 'wp_options' is marked as crashed and last (automatic?) repair failed in hatasının çözümü

```
If your MySQL process is running, stop it. On Debian:

sudo service mysql stop
Go to your data folder. On Debian:

cd /var/lib/mysql/$DATABASE_NAME
Try running:

myisamchk -r $TABLE_NAME
If that doesn't work, you can try:

myisamchk -r -v -f $TABLE_NAME
You can start your MySQL server again. On Debian:

sudo service mysql start
```
