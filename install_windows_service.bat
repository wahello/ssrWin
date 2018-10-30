:: Copyright 2018 The Outline Authors
::
:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::      http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

:: Stops/uninstalls and starts/reinstalls service.
:: Intended to be called by both the installer and client.
::
:: Does *not* fail if any step fails: the caller must check
:: whether the service is actually running (see final exit statement).

@echo off
setlocal EnableDelayedExpansion

set PWD=%~dp0%
set SVC_NAME=ssrRouteService
set BIN_FILE=ssrRouteService.exe

:: Stop and delete the service.
sc stop %SVC_NAME%
sc delete %SVC_NAME%

timeout /t 2

:: Install and start the service, configuring it to restart on boot.
:: NOTE: spaces after the arguments are necessary for a correct installation, do not remove!
sc create %SVC_NAME% binpath= "%PWD%%BIN_FILE%" displayname= "%SVC_NAME%" start= "auto"
sc start %SVC_NAME%

:: This is for the client: sudo-prompt discards stdout/stderr if the script
:: exits with a non-zero return code *which will happen if any of the previous
:: commands failed*.
exit /b 0
