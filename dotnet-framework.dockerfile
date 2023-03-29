############################################################################
#                                                                          #
# Sets up a Windows Server with IIS, .NET Framework                        #
#                                                                          #
############################################################################

FROM mcr.microsoft.com/windows:ltsc2019

# Enable IIS
RUN dism /online /enable-feature /all /featurename:iis-webserver

# Enable IIS ASPNET45
RUN dism /online /enable-feature /all /featurename:iis-aspnet45

#
RUN iisreset

# Expose port 80 for web traffic
EXPOSE 80

