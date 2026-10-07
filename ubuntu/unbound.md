# dns sorgusu populatize

```sh
awk '/resolving/ {dom=$5} /NXDOMAIN|SERVFAIL|nodata/ {print dom, $0}' /my-directory/unbound/unbound.log | awk '{print $1}' | sed 's/\.$//' | sort | uniq -c | sort -nr | head -n 10
```
