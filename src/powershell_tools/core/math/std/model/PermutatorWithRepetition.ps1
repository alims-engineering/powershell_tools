# ====================================
#           explanation
# ====================================
# Combinator_repetition is a class that generates all possible combinations of characters from a given set of base words. 
# It allows for repetition of characters,
# meaning that the same character can be used multiple times in the generated combinations.
#
# ====================================
#           actions
# ====================================
# A dictionary and a current word are stored.
# You can choose to move forward or backward.
#
#
# ====================================
#           functions
# ====================================
# GetCurrentWord: Return the current combination of characters.
# GetNextCombination: Return the next combination of characters without updating the CurrentWord.
# ToNextCombination: Update the CurrentWord to the next combination of characters based on the BaseWords.
#


# number (10): 0 - 9
# small alphabet (26): a - z
# capital alphabet (26): A - Z
# special characters (32): ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
# space (1): " "
# total: 95 characters (printable ASCII characters)
$Combinator_repetition_default_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!""#$%&'()*+,-./:;<=>?@[\]^_`{|}~ "

class PermutatorWithRepetition {
    [string]$BaseWords = $Combinator_repetition_default_characters
    [string]$CurrentWord = $Combinator_repetition_default_characters[0]

    PermutatorWithRepetition([string]$baseWords) {
        $this.BaseWords = $baseWords
        $this.CurrentWord = $baseWords[0]
    }


    [string]ToNextCombination() {
        if (-not $this.CheckCurrentWordIsInBaseWords()) {
            throw "[] Current word contains characters that are not in the base words."
        }

        for($i = 0; $i -lt $this.CurrentWord.Length; $i++){
            for ($j = 0; $j -lt $this.BaseWords.Length; $j++){
                
                if ($this.CurrentWord[$i] -eq $this.BaseWords[$j]){
                    if ($j + 1 -ge $this.BaseWords.Length){
                        
                        $chars = $this.CurrentWord.ToCharArray()
                        $chars[$i] = $this.BaseWords[0]
                        $this.CurrentWord = -join $chars

                    }else{
                        Write-Host "current base word $($this.BaseWords[$j]) index $j"

                        $chars = $this.CurrentWord.ToCharArray()
                        $chars[$i] = $this.BaseWords[$j + 1]
                        $this.CurrentWord = -join $chars
                        break
                    }
                }
            }
        }

        return $this.CurrentWord
    }

    hidden [boolean] CheckCurrentWordIsInBaseWords() {
        foreach ($char in $this.CurrentWord.ToCharArray()){
            if (-not $this.BaseWords.Contains($char)){
                return $false
            }
        }
        return $true
    }

}