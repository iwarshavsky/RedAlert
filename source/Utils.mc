import Toybox.Lang;
module Utils {
    /*
    Replace all occurrences of substring with a different string in a string
    */
    function replaceAll(str, findStr, replaceStr) {
        var result = "";
        var current = str;
        var idx = current.find(findStr);

        while (idx != null) {
            result += current.substring(0, idx) + replaceStr;
            current = current.substring(idx + findStr.length(), null);
            idx = current.find(findStr);
        }

        return result + current;
    }

    /*
    Returns true if target is in array after the array is normalized
    */
    function arrayContainsString(array as Array<String>, target) {
        for (var i = 0; i < array.size(); i += 1) {
            var normalized_str = replaceAll(array[i],"\\u0027", "'");
            if (normalized_str.find(target) != null) {
                return true;
            }
        }
        return false;
    }
}
