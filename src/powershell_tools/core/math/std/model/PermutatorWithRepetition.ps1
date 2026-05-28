# ====================================
#           explanation
# ====================================
# PermutatorWithRepetition is a class that generates all possible permutations of characters from a given set of base words. 
# It allows for repetition of characters,
# meaning that the same character can be used multiple times in the generated permutations.
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
# GetCurrentWord: Return the current permutation of characters.
# GetNextPermutation: Return the next permutation of characters without updating the CurrentWord.
# ToNextPermutation: Update the CurrentWord to the next permutation of characters based on the BaseWords.
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

    [string]GetNextPermutation() {
        $temp = [PermutatorWithRepetition]::new($this.BaseWords)
        $temp.CurrentWord = $this.CurrentWord
        
        return $temp.ToNextPermutation()
    }

    [string]ToNextPermutation() {
        if (-not $this.CheckCurrentWordIsInBaseWords()) {
            throw "[] Current word contains characters that are not in the base words."
        }

        # Carry over starting from the far right.
        for ($i = $this.CurrentWord.Length - 1; $i -ge 0; $i--) {
            # Find the index of the current character in BaseWords
            $currentChar = $this.CurrentWord[$i]
            $currentIndex = $this.BaseWords.IndexOf($currentChar)
            
            # If it's not the last character, we can increment it
            if ($currentIndex -lt $this.BaseWords.Length - 1) {
                # Increment the current character to the next one in BaseWords and return
                $chars = $this.CurrentWord.ToCharArray()
                $chars[$i] = $this.BaseWords[$currentIndex + 1]
                $this.CurrentWord = -join $chars
                return $this.CurrentWord
            }
            else {
                # The current position is already the last character
                # Reset to the first character, and continue carrying over
                $chars = $this.CurrentWord.ToCharArray()
                $chars[$i] = $this.BaseWords[0]
                $this.CurrentWord = -join $chars
            }
        }
        
        # All positions have been carried over, add a new position
        $this.CurrentWord = $this.BaseWords[0] + $this.CurrentWord
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