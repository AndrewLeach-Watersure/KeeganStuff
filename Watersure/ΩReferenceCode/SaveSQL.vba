Function SaveSQL(filename As String, myrng As Range) As Boolean
Dim lineText As String
Open filename For Output As #1
Print #1, myrng
Close #1
End Function

