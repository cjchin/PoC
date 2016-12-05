# EMACS settings: -*-	tab-width: 2; indent-tabs-mode: t -*-
# vim: tabstop=2:shiftwidth=2:noexpandtab
# kate: tab-width 2; replace-tabs off; indent-width 2;
#
# ==============================================================================
#	Authors:						Patrick Lehmann
#
#	PowerShell Module:
#
# Description:
# ------------------------------------
#	TODO:
#		-
#
# License:
# ==============================================================================
# Copyright 2007-2016 Technische Universitaet Dresden - Germany
#                     Chair of VLSI-Design, Diagnostics and Architecture
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
#
function Open-Environment
{	$Debug = $true	#$false

	# load Lattice Diamond environment if not loaded before
	if (-not (Test-Path env:FOUNDRY))
	{	$Diamond_InstallationDirectory = PoCQuery "INSTALL.Lattice.Diamond:InstallationDirectory"
		if ($LastExitCode -ne 0)
		{	Write-Host "[ERROR]: ExitCode for '$PoC_Command' was not zero. Aborting execution." -ForegroundColor Red
			Write-Host "       $Diamond_InstallationDirectory" -ForegroundColor Red
			return 1
		}
		elseif ($Diamond_InstallationDirectory -eq "")
		{	Write-Host "[ERROR]: No Lattice Diamond installation found." -ForegroundColor Red
			Write-Host "Run 'poc.ps1 configure' to configure your Lattice Diamond installation." -ForegroundColor Red
			return 1
		}
		elseif (-not (Test-Path $Diamond_InstallationDirectory))
		{	Write-Host "[ERROR]: Lattice Diamond is configured in PoC, but installation directory '$Diamond_InstallationDirectory' does not exist." -ForegroundColor Red
			Write-Host "Run 'poc.ps1 configure' to configure your Lattice Diamond installation." -ForegroundColor Red
			return 1
		}

		Write-Host "Loading Lattice Diamond environment..." -ForegroundColor Yellow
		$env:LSC_INI_PATH =	""
		$env:LSC_DIAMOND =	"true"
		$env:FOUNDRY =			"$Diamond_InstallationDirectory\ispFPGA"
		$env:TCL_LIBRARY =	"$Diamond_InstallationDirectory\tcltk\lib\tcl8.5"
		return 0
	}
	elseif (-not (Test-Path $env:FOUNDRY))
	{	Write-Host "[ERROR]: Environment variable FOUNDRY is set, but the path does not exist." -ForegroundColor Red
		Write-Host ("  FOUNDRY=" + $env:FOUNDRY) -ForegroundColor Red
		$env:FOUNDRY = $null
		return Load-Environment
	}
}

function Close-Environment
{	Write-Host "Unloading Lattice Diamond environment..." -ForegroundColor Yellow
	$env:LSC_INI_PATH =	$null
	$env:LSC_DIAMOND =	$null
	$env:FOUNDRY =			$null
	$env:TCL_LIBRARY =	$null
	return 0
}
