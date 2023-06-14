Sub HLREPORT()
'
' Macro for high level report
'

Dim Cur_wbk As Workbook
Set Cur_wbk = ActiveWorkbook
Dim Cur_ws As Worksheet
Set Cur_ws = Cur_wbk.ActiveSheet
Dim sht As Worksheet
Dim pvtCache As PivotCache
Dim pvt As PivotTable
Dim StartPvt As String
Dim SrcData As String
Dim lastRow As Long, x As Long
lastRow = Cur_ws.Range("A" & Rows.Count).End(xlUp).Row
Dim lastCol As Long
lastCol = Cur_ws.Cells(1, Columns.Count).End(xlToLeft).Column

'Determine the data range you want to pivot
  SrcData = ActiveSheet.Name & "!" & Range(Cells(1, 1), Cells(lastRow, lastCol)).Address(ReferenceStyle:=xlR1C1)
'Create a new worksheet
  Set sht = Sheets.Add
'Where do you want Pivot Table to start?
  StartPvt = sht.Name & "!" & sht.Range("A3").Address(ReferenceStyle:=xlR1C1)
'Create Pivot Cache from Source Data
  Set pvtCache = ActiveWorkbook.PivotCaches.Create( _
    SourceType:=xlDatabase, _
    SourceData:=SrcData)
'Create Pivot table from Pivot Cache
  Set pvt = pvtCache.CreatePivotTable( _
    TableDestination:=StartPvt, _
    TableName:="HLReport")
    
    With pvt.PivotFields("1-Pivot")
        .Orientation = xlRowField
        .Position = 1
    End With
    With pvt.PivotFields("2-Pivot")
        .Orientation = xlRowField
        .Position = 2
    End With
    With pvt.PivotFields("3-Pivot")
        .Orientation = xlRowField
        .Position = 3
    End With
    With pvt.PivotFields("4-Pivot")
        .Orientation = xlRowField
        .Position = 4
    End With
    
    pvt.AddDataField pvt.PivotFields("Act. Rem. Hrs"), "Sum of Act. Rem. Hrs", xlSum
    With pvt.PivotFields("Act. Start")
        .Orientation = xlColumnField
        .Position = 1
        
    End With
     Range("B4").Select
    Selection.Group Start:=43101, End:=43465, Periods:=Array(False, False, _
        False, False, True, False, True)
    pvt.PivotFields("3-Pivot").ShowDetail = _
        False
    Columns("B:P").Select
    Selection.Style = "Comma"
    Selection.NumberFormat = "_-* #,##0.0_-;-* #,##0.0_-;_-* ""-""??_-;_-@_-"
    Selection.NumberFormat = "_-* #,##0_-;-* #,##0_-;_-* ""-""??_-;_-@_-"
    Cells.Select
    Cells.EntireColumn.AutoFit
    ActiveSheet.PivotTables("HLReport").TableStyle2 = "PivotStyleLight8"
    ActiveSheet.PivotTables("HLReport").PivotFields("Years").Subtotals = Array(True _
        , False, False, False, False, False, False, False, False, False, False, False)
    ActiveSheet.PivotTables("HLReport").SubtotalLocation xlAtBottom
    Range("C4").Select
    ActiveSheet.PivotTables("HLReport").PivotFields("Years").Subtotals = Array( _
        False, False, False, False, False, False, False, False, False, False, False, False)
    Range("A36").Select
    ActiveSheet.PivotTables("HLReport").PivotFields("2-Pivot").Subtotals = Array( _
        False, False, False, False, False, False, False, False, False, False, False, False)
    Range("A35").Select
    ActiveSheet.PivotTables("HLReport").PivotFields("3-Pivot").PivotItems( _
        "Summary - PROJ").ShowDetail = True
    Range("A51").Select
    ActiveSheet.PivotTables("HLReport").PivotFields("3-Pivot").Subtotals = Array( _
        False, False, False, False, False, False, False, False, False, False, False, False)
    ActiveWindow.SmallScroll Down:=-42
    Range("A35").Select
    ActiveSheet.PivotTables("HLReport").PivotFields("3-Pivot").PivotItems( _
        "Summary - PROJ").ShowDetail = False
    ActiveWindow.SmallScroll Down:=-28
    
    Workbooks("HLREPORT bd3a62ef.xlsm").Close
   
End Sub