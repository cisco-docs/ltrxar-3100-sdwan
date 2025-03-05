# use this function to replace the escape characters in the text with __n__ or __r__ or __t__ or __s__
import re

def replace_escape_characters(text):
        """Replaces occurrences of the pattern in the text with the replacement."""
        results = []
        try:
                if re.search(r'(\\n|\\t|\\r)', text[0]): # check if the text contains \\n or \\t or \\r or space and replace them with  __n__ or __r__ or __t__
                        sp_text = text[0].replace("\\n", "__n__").replace("\\r", "__r__").replace("\\t", "__t__").replace(" ","__s__")
                        results.append(sp_text)
                elif re.search(r'[\n\t\r]', text[0]):  # check if the text contains \n or \t or \r or space and replace them with __n__ or __r__ or __t__
                        sp_text = text[0].replace("\n", "__n__").replace("\r", "__r__").replace("\t", "__t__").replace(" ","__s__")
                        results.append(sp_text)
                else:
                        results.append(text[0])
        except:
                pass
        return results