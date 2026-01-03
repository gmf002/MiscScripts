# RandomBirthday, a collection of functions

## Background

I role play on occasion, and I find it useful to have a birthday.  From that I can look up the zodiac signs, which allows me to apply some stereotypical traits to the character.  I find this to be a useful starting point in fleshing out a character's personality.

This script was created to make that task easier.

## System Requirements

This script has no Windows specific code and should work on any operating system that PowerShell runs on.

## Loading the script

Load the script by dot sourcing it into your current PowerShell session

```PowerShell
. .\RandomBirthday.ps1
```

## Using the functions

### Generate a birthday with zodiac signs

The defaults for MinYear and MaxYear are 1970 and 2100 respectively.  If you do not provide these parameters, those are the values that will be used.

```PowerShell
New-Birthday -MinYear 1970 -MaxYear 2100
```

Example Output
<blockquote>
Birthday            : Tuesday, May 21, 2002 16:21:58<br>
Zodiac Sign         : Gemini<br>
Chinese Zodiac Sign : Horse<br>
<br>
Zodiac signs are based on static lookups and rough calculations.<br>
These dates shift by year based on solar and lunar positions.<br>
If you want to be certain, use an Internet service or calculate it yourself.
</blockquote>

### Generate a random height and weight

The height is first generate in feet as a random number between 5 and 7 inclusive.
*  If feet is 7, inches are randomly generated with a maximum of 5.
*  If feet is 5, inches are ramdomly generated with a minimum of 1 and maximum of 11.
*  Anything else (aka feet of 6), use a maximum of 11.

Four formulas are used to generate weight: Hamwi64, Devine74, Robinson83, and Miller83.  For each one, a minimum weight is calculated using the female formuias, and a max weight is calculated using the male formualas.  The min and max weights of each are averaged, and a random number of 0-19 added (the weights felt low for an athletic individual, which most RPG characters are in the games I play).  The averaged min and max weights are then used as the minimum and maximum input for the built-in Get-Random function to provide a random weight.

```PowerShell
New-HumanDimensions
```

Example Output
<blockquote>
Maximum Height : 188 cm or 6' 2"<br>
Average Weight : 63.6 kg or 140.2 pounds
</blockquote>

### Get zodiac signs

#### Western

```PowerShell
Get-ZodiacSign (Get-Date "1/1/1900")
```

> Capricorn

#### Chinese

The Chinese calendar in DotNet only accepts years from 1901 to 2100, inclusive. This is used to determine the day of the Chinese New Year.

If a year outside of that range is provided, the calculation will still run, but a dat between Jan 21 and Feb 20 will possibly be incorrect because teh Chinese New Year is not known.

```PowerShell
Get-ChineseZodiacSign (Get-Date "1/1/1900")
```

> Rat
