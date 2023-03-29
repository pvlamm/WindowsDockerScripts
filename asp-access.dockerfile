############################################################################
#                                                                          #
# Sets up a Windows Server with IIS, Classic ASP and MS Access Support     #
#                                                                          #
############################################################################
############################################################################
#                                                                          #
# Sets up a Windows Server with IIS, Classic ASP and MS Access Support     #
#                                                                          #
############################################################################

# FROM mcr.microsoft.com/windows:ltsc2019
FROM mcr.microsoft.com/windows/servercore/iis

SHELL ["powershell", "-command"]

RUN Install-WindowsFeature Web-ASP; \
    Install-WindowsFeature Web-CGI; \
    Install-WindowsFeature Web-ISAPI-Ext; \
    Install-WindowsFeature Web-ISAPI-Filter; \
    Install-WindowsFeature Web-Includes; \
    Install-WindowsFeature Web-HTTP-Errors; \
    Install-WindowsFeature Web-Common-HTTP; \
    Install-WindowsFeature Web-Performance; \
    Install-WindowsFeature WAS; \
    Import-module IISAdministration;

#RUN md c:/msi;

#RUN Invoke-WebRequest 'http://download.microsoft.com/download/C/9/E/C9E8180D-4E51-40A6-A9BF-776990D8BCA9/rewrite_amd64.msi' -OutFile c:/msi/urlrewrite2.msi; \
#    Start-Process 'c:/msi/urlrewrite2.msi' '/qn' -PassThru | Wait-Process;

#RUN Invoke-WebRequest 'https://download.microsoft.com/download/1/E/7/1E7B1181-3974-4B29-9A47-CC857B271AA2/English/X64/msodbcsql.msi' -OutFile c:/msi/msodbcsql.msi; 
#RUN ["cmd", "/S", "/C", "c:\\windows\\syswow64\\msiexec", "/i", "c:\\msi\\msodbcsql.msi", "IACCEPTMSODBCSQLLICENSETERMS=YES", "ADDLOCAL=ALL", "/qn"];

EXPOSE 8000
RUN Remove-Website -Name 'Default Web Site'; \
    md c:\mywebsite; \
    New-IISSite -Name "mywebsite" \
                -PhysicalPath 'c:\mywebsite' \
                -BindingInformation "*:80:";

WORKDIR /mywebsite

COPY web/ .

RUN & c:\windows\system32\inetsrv\appcmd.exe \
    unlock config \
    /section:system.webServer/asp

RUN & c:\windows\system32\inetsrv\appcmd.exe \
      unlock config \
      /section:system.webServer/handlers

RUN & c:\windows\system32\inetsrv\appcmd.exe \
      unlock config \
      /section:system.webServer/modules

WORKDIR /windows/system32/inetsrv

RUN & c:\windows\system32\inetsrv\appcmd.exe set config "mywebsite" -section:system.webServer/asp /enableParentPaths:"True" /commit:apphost
