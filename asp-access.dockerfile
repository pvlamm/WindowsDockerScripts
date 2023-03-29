############################################################################
#                                                                          #
# Sets up a Windows Server with IIS, Classic ASP and MS Access Support     #
#                                                                          #
############################################################################

FROM mcr.microsoft.com/windows:ltsc2019

# Enable IIS
RUN dism /online /enable-feature /all /featurename:iis-webserver

# Enable IIS CLassic-ASP
RUN dism /online /enable-feature /all /featurename:iis-asp

WORKDIR /windows/system32/inetsrv

# Enable Parent Paths in asp code
RUN appcmd.exe set config "Default Web Site" -section:system.webServer/asp /enableParentPaths:"True" /commit:apphost

WORKDIR /inetpub/wwwroot

# Rework web/ to code source
COPY web/ .

#
RUN iisreset

# Expose port 80 for web traffic
EXPOSE 80

