EXCEL 2007 / 2012 – OPEN TWO SPREADSHEETS IN TWO SEPARATE WINDOWS
2012-07-26BY GÁBOR HARGITAI1 MIN READADD COMMENT
Ever wanted to open a spreadsheet like you did before Excel 2007? Now it is possible and it comes in handy if you need to compare documents side-by-side.

Start Regedit (WinKey + R, type in “regedit” without the quotation marks and hit Enter)Navigate to:

```
HKEY_CLASSES_ROOT/Excel.Sheet.8/shell/Open/command
Double Click on (Default) and write:

"C:\Program Files\Microsoft Office\Office12\EXCEL.EXE" /e "%1"
Right Click on Command – choose “rename” and enter:
```
command2
Right Click on the folder “ddeexec” (in the tree view at the left) and choose “rename” and enter:

ddeexec2
Navigate to:
```
HKEY_CLASSES_ROOT/Excel.Sheet.12/shell/Open/command
Double Click on (Default) and write:

"C:\Program Files\Microsoft Office\Office12\EXCEL.EXE" /e "%1"
Right Click on Command – choose “rename” and enter:
```
command2
Right Click on the folder “ddeexec” (in the tree view at the left) and choose “rename” and enter:

ddeexec2
We’re done! The spreadsheet you’ll open next will behave as intended.

Credit goes to the source, as this is a reposted/reblogged edit!
