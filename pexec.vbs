''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'' pexec.vbs
'' v1.00, 2014-11-05, 03:31:36 CST
''
'' AUTHOR: Mark R. Gollnick <mark.r.gollnick@gmail.com>
'' HOMEPAGE: http://github.com/markgollnick
''
'' DESCRIPTION:
''   Print the parent process location. Useful for iexpress.exe packages.
''
'' USAGE:
''   cscript pexec.vbs p.exe (if called from cmd.exe, calls "p.exe cmd.exe")
''   wscript pexec.vbs p.exe (calls "p.exe explorer.exe", etc.)
''
'' ACKNOWLEDGEMENTS:
''   http://stackoverflow.com/questions/13534699/iexpress-extraction-path/13700281#13700281
''   http://msdn.microsoft.com/en-us/library/aa394599(v=vs.85).aspx
''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

Option Explicit

Dim objShell, objWMI, objCmd, objMyParent
Dim strCmd, strMyParentPath
Dim intMyPid, intMyParentPid

If WScript.Arguments.Count < 1 Then
  WScript.Echo(_
    "pexec 1.00, a parental executor." & vbCrLf & _
    "Usage: [c|w]script " & WScript.ScriptName & " <cmd>" & vbCrLf & _
    vbCrLf & _
    "Example:" & vbCrLf & _
    """cscript pexec.vbs program.exe"", if run from cmd.exe," & vbCrLf & _
    "will call ""program.exe C:\path\to\cmd.exe""." & vbCrLf & _
    "This is useful for iexpress.exe packages and the like." _
  )
  WScript.Quit
Else
  strCmd = WScript.Arguments(0)
End If

Set objShell = CreateObject("WScript.Shell")
Set objWMI = GetObject("winmgmts:\\.\root\CIMV2")

Set objCmd = objShell.Exec("cmd.exe")
intMyPid = objWMI.Get("Win32_Process.Handle='" & objCmd.ProcessID & "'").ParentProcessId
objCmd.Terminate

intMyParentPid = objWMI.Get("Win32_Process.Handle='" & intMyPid & "'").ParentProcessId
Set objMyParent = objWMI.Get("Win32_Process.Handle='" & intMyParentPid & "'")
strMyParentPath = objMyParent.ExecutablePath

'' WScript.Echo strCmd & " " & """" & strMyParentPath & """"
objShell.Run strCmd & " " & """" & strMyParentPath & """"