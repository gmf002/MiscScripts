
Function Get-RandomYear {
    param(
        [int]$MinYear,
        [int]$MaxYear
    )

    $i = Get-Random -Minimum $MinYear -Maximum (++$MaxYear)

    return "{0}" -f $i
}

Function Get-RandomMonth {
    $i = Get-Random -Minimum 1 -Maximum 13

    return "{0}" -f $i
}

Function Get-RandomDay {
    param(
        [int]$Year,
        [int]$Month
    )

    [int]$MaxDays = 31;

    if($Month -eq 2) {
        if(IsLeapYear -Year $Year) {
            $MaxDays = 29
        } else  {
            $MaxDays = 28
        }
    }

    if(@(4,6,9,11) -contains $Month) {
        $MaxDays = 30
    }

    $i = Get-Random -Minimum 1 -Maximum (++$MaxDays)

    return "{0}" -f $i
}

Function IsLeapYear {
    param(
        [int]$Year
    )

    if($Year % 400 -eq 0 -or ($Year % 4 -eq 0 -and $Year % 100 -ne 0)) {
        return $true
    }

    return $false
}


Function Get-RandomBirthday {
    param(
        [int]$MinYear = 1970,
        [int]$MaxYear = 9990
    )

    $year = Get-RandomYear -MinYear $MinYear -MaxYear $MaxYear
    $month = Get-RandomMonth
    $day = Get-RandomDay -Year $year -Month $month
    $hour = Get-Random -Maximum 24
    $minute = Get-Random -Minimum 1 -Maximum 60

    return Get-Date -Year $year -Month $month -Day $day -Hour $hour -Minute $minute 
}

Function Get-RandomHeight {
    $feet = Get-Random -Minimum 5 -Maximum 8
    $inches = 0;

    if ($feet -eq 7) {
        $inches = Get-Random -Minimum 0 -Maximum 6
    } elseif($feet -eq 5) {
        $inches = Get-Random -Minimum 8 -Maximum 12
    } else {
        $inches = Get-Random -Minimum 0 -Maximum 12
    }

    return ($feet * 12) + $inches
}

Function Get-RandomWeight {
    param(
        [int]
        $HeightInches
    )

    $inchesOver5ft = $HeightInches - 60;
    if($inchesOver5ft -lt 0) { $inchesOver5ft = 0 }

    # Height in inches, weights in kilograms
    $models = @{
        # Min: female Max: male
        Hamwi64 = @{ MinWeight = [decimal](45.5 + $inchesOver5ft * 2.2); MaxWeight = [decimal](48 + $inchesOver5ft * 2.7) };
        Devine74 = @{ MinWeight = [decimal](45.5 + $inchesOver5ft * 2.3); MaxWeight = [decimal](50 + $inchesOver5ft * 2.3) };
        Robinson83 = @{ MinWeight = [decimal](49 + $inchesOver5ft * 1.7); MaxWeight = [decimal](52 + $inchesOver5ft * 1.9) };
        Miller83 = @{ MinWeight = [decimal](53.1 + $inchesOver5ft * 1.36); MaxWeight = [decimal](56.2 + $inchesOver5ft * 1.41) };
    }

    $averageMinWeightKg = ($models['Hamwi64']['MinWeight'] + $models['Devine74']['MinWeight'] + $models['Robinson83']['MinWeight'] + $models['Miller83']['MinWeight']) / $models.Count;
    $averageMaxWeightKg = ($models['Hamwi64']['MaxWeight'] + $models['Devine74']['MaxWeight'] + $models['Robinson83']['MaxWeight'] + $models['Miller83']['MaxWeight']) / $models.Count;
    $lowerThreshold = -([Math]::Floor((Get-Random -Minimum 0 -Maximum 20)))
    $upperThreshold = [Math]::Ceiling((Get-Random -Minimum 0 -Maximum 20))
    $min =  $averageMinWeightKg + $lowerThreshold
    $max = $averageMaxWeightKg + $upperThreshold

    $weightKg = [Math]::Round((Get-Random -Minimum $min -Maximum $max), 1);

    $weightLbs = [Math]::Round(($weightKg * 2.20462262185), 1);

    return $("$weightKg kg or $weightLbs pounds")
}

Function Get-ZodiacSign {
    param(
        [datetime]$Birthday
    )

    $signs = @(
        [PSCustomObject]@{Name = "Aries"; StartDate = (Get-Date -Month 3 -Day 21); EndDate = (Get-Date -Month 4 -Day 19)},
        [PSCustomObject]@{Name = "Taurus"; StartDate = (Get-Date -Month 4 -Day 20); EndDate = (Get-Date -Month 5 -Day 20)},
        [PSCustomObject]@{Name = "Gemini"; StartDate = (Get-Date -Month 5 -Day 21); EndDate = (Get-Date -Month 6 -Day 20)},
        [PSCustomObject]@{Name = "Cancer"; StartDate = (Get-Date -Month 6 -Day 21); EndDate = (Get-Date -Month 7 -Day 22)},
        [PSCustomObject]@{Name = "Leo"; StartDate = (Get-Date -Month 7 -Day 23); EndDate = (Get-Date -Month 8 -Day 22)},
        [PSCustomObject]@{Name = "Virgo"; StartDate = (Get-Date -Month 8 -Day 23); EndDate = (Get-Date -Month 9 -Day 22)},
        [PSCustomObject]@{Name = "Libra"; StartDate = (Get-Date -Month 9 -Day 23); EndDate = (Get-Date -Month 10 -Day 22)},
        [PSCustomObject]@{Name = "Scorpio"; StartDate = (Get-Date -Month 10 -Day 23); EndDate = (Get-Date -Month 11 -Day 21)},
        [PSCustomObject]@{Name = "Sagittarius"; StartDate = (Get-Date -Month 11 -Day 22); EndDate = (Get-Date -Month 12 -Day 21)},
        [PSCustomObject]@{Name = "Capricorn"; StartDate = (Get-Date -Month 12 -Day 21); EndDate = (Get-Date -Month 1 -Day 20)},
        [PSCustomObject]@{Name = "Aquarius"; StartDate = (Get-Date -Month 1 -Day 21); EndDate = (Get-Date -Month 2 -Day 18)},
        [PSCustomObject]@{Name = "Pisces"; StartDate = (Get-Date -Month 2 -Day 19); EndDate = (Get-Date -Month 3 -Day 20)}
    )

    foreach($sign in $signs) {
        if(($Birthday.Month -eq $sign.StartDate.Month -and $Birthday.Day -ge $sign.StartDate.Day) -or
           ($Birthday.Month -eq $sign.EndDate.Month -and $Birthday.Day -le $sign.EndDate.Day)) {
            return $sign.Name
        }
    }
}

Function Get-ChineseZodiacSign {
    param(
        [datetime]$Birthday
    )

    $chineseNewYear = [Globalization.ChineseLunisolarCalendar]::new().ToDateTime([DateTime]::Now.Year, 1, 1, 0,0,0,0)
    $signs = @("Pig", "Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake", "Horse", "Sheep", "Monkey", "Rooster", "Dog")
    $signNumber = ($Birthday.Year + 9) % 12
    $previousSignNumber = 0

    if($signNumber -eq 0) {
        $previousSignNumber = 11
    } else {
        $previousSignNumber = $signNumber - 1
    }

    if($Birthday -lt $chineseNewYear) {
        return $signs[$previousSignNumber]
    } else {
        return $signs[$signNumber]
    }
}

Function New-Birthday {
    param(
        [int]$MinYear = 1970,
        [int]$MaxYear = 2100
    )

    $disclaimer = @"
Zodiac signs are based on static lookups and rough calculations.
These dates shift by year based on solar and lunar positions.
If you want to be certain, use an Internet service or calculate it yourself.
"@

    $birthday = Get-RandomBirthday -MinYear $MinYear -MaxYear $MaxYear
    $zodiacSign = Get-ZodiacSign -Birthday $birthday
    $chineseZodiacSign = Get-ChineseZodiacSign -Birthday $birthday
    
    Write-Host
    Write-Host ('Birthday            : {0:F}' -f $birthday)
    Write-Host ('Zodiac Sign         : {0}' -f $zodiacSign)
    Write-Host ('Chinese Zodiac Sign : {0}' -f $chineseZodiacSign)
    Write-Host
    Write-Host $disclaimer
    Write-Host
}

Function New-HumanDimensions {
    $height = Get-RandomHeight
    $feet = [Math]::Floor($height / 12)
    $inches = $height % 12
    $centimeters = [Math]::Round($height * 2.54, 1)

    $weight = Get-RandomWeight -HeightInches $height

    Write-Host
    Write-Host ('Maximum Height : {0} cm or {1}'' {2}"' -f $centimeters, $feet, $inches)
    Write-Host ('Average Weight : {0}' -f $weight)
    Write-Host
}
