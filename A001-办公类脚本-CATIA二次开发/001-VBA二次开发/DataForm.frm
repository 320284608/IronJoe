VERSION 5.00
Begin {C62A69F0-16DC-11CE-9E98-00AA00574A4F} DataForm 
   Caption         =   "����������"
   ClientHeight    =   3015
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   4560
   OleObjectBlob   =   "DataForm.frx":0000
   StartUpPosition =   1  'CenterOwner
End
Attribute VB_Name = "DataForm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub cancelBTN_Click()
    End
End Sub

Private Sub confirmBTN_Click()
    
    If dataSuffix = "igs" Or dataSuffix = "stp" Then
        Call solidBatch(dataSuffix)
    ElseIf dataSuffix = "dwg" Or dataSuffix = "pdf" Then
        Call drawingBatch(dataSuffix)
    End If
    
    MsgBox ("����������ɣ�����")
    
End Sub


Private Sub inputBRO_Click()
    inPath.Value = FolderBroswer
End Sub

Private Sub outputBRO_Click()
    outPath.Value = FolderBroswer
End Sub

Function dataSuffix() As String
    
    Select Case OptionButton
    
    Case igsBTN.Value = False
        dataSuffix = "igs"
    Case stpBTN.Value = False
        dataSuffix = "stp"
    Case dwgBTN.Value = False
        dataSuffix = "dwg"
    Case pdfBTN.Value = False
        dataSuffix = "pdf"
        
    End Select
    
End Function

Function solidBatch(ByVal Suffix As String)

Dim folderinput As String
Dim folderoutput As String

folderinput = inPath.Text
folderoutput = outPath.Text

Dim fs As Object
Dim f As Object
Dim f1 As Object
Dim fc As Object

Set fs = CATIA.FileSystem         'CATIA�ĵ�ϵͳ
Set f = fs.GetFolder(folderinput) '��ȡ����·��λ��
Set fc = f.Files                  '�ļ�����

'��׺��ָ��
Dim SuffixAdd As String

SuffixAdd = "." & Suffix

'���������ڵ��ļ�
For Each f1 In fc

    Set documents1 = CATIA.Documents
    
    Dim INTRARE As String
    INTRARE = CATIA.FileSystem.ConcatenatePaths(folderinput, f1.Name)
    
    Set PartDocument1 = documents1.Open(INTRARE)
    
    '�ַ����ָ��Ϊ����
    Dim docname As String
    Dim pathname As String
    Dim IESIRE As String
    
    docname = Split(f1.Name, ".")(0)

    pathname = folderoutput & "\" & docname
    
    
    IESIRE = pathname & SuffixAdd
    
    PartDocument1.ExportData IESIRE, Suffix


    CATIA.ActiveDocument.Close
    
    Next

End Function

Function drawingBatch(ByVal Suffix As String)

Dim folderinput As String
Dim folderoutput As String

folderinput = inPath.Text
folderoutput = outPath.Text

Dim fs As Object
Dim f As Object
Dim f1 As Object
Dim fc As Object

Set fs = CATIA.FileSystem         'CATIA�ĵ�ϵͳ
Set f = fs.GetFolder(folderinput) '��ȡ����·��λ��
Set fc = f.Files                  '�ļ�����

'��׺��ָ��
Dim SuffixAdd As String

SuffixAdd = "." & Suffix

'���������ڵ��ļ�
For Each f1 In fc
    

    '�����ļ�����
    Dim INTRARE As String
    INTRARE = CATIA.FileSystem.ConcatenatePaths(folderinput, f1.Name)
    
    If InStr(f1.Name, ".CATDrawing") = 0 Then
        MsgBox (f1.Name)
        GoTo Continue
    End If
    
    '����ļ�����·����
    '�ַ����ָ��Ϊ����
    docname = Split(f1.Name, ".")(0)
    pathname = folderoutput & "\" & docname
    
    '����ͼ���ļ�����
    Set drawingDocuments = CATIA.Documents

    
    '��ͼ���ļ�
    Dim drawingDocument1 As Document
    Set drawingDocument1 = drawingDocuments.Open(INTRARE)
    
    Dim drawingSheets1 As DrawingSheets
    Set drawingSheets1 = drawingDocument1.Sheets
    
    Dim drawingSheet1 As DrawingSheet
    Set drawingSheet1 = drawingSheets1.ActiveSheet
    
    Dim IESIRE As String
    IESIRE = pathname & SuffixAdd
    
    drawingDocument1.ExportData IESIRE, Suffix
    
    CATIA.ActiveDocument.Close
Continue:
    Next

End Function


Function FolderBroswer() As String

'=================================================================================================
' TITLE: BrowseForFolderDialogBox
'
' PURPOSE: Open Window dialog box to choose directory to process.
' Return the choosen path to a variable.
'
' HOW TO USE: strResult = BrowseForFolderDialogBox()
' ==================================================

Const WINDOW_HANDLE = 0
Const NO_OPTIONS = &H1
Dim objShellApp
Dim objFolder
Dim objFldrItem
Dim objPath

Set objShellApp = CreateObject("Shell.Application")
Set objFolder = objShellApp.BrowseForFolder(WINDOW_HANDLE, strTitle, NO_OPTIONS)


Set objFldrItem = objFolder.Self
objPath = objFldrItem.Path

Set objShellApp = Nothing
Set objFolder = Nothing
Set objFldrItem = Nothing

FolderBroswer = objPath
End Function

