# Office365 mailbox ın içinde mail araması yapar ve bir postakutusuna export eder.

```
Search-Mailbox -Identity mailadresi@example.pl -SearchQuery {from:mail.adresi@example.pl AND Received:"01/01/2021 00:00..13.07.2021 15:26"} -TargetMailbox arama.sonucu@example.pl -TargetFolder "Gelen mailler"
  ```
