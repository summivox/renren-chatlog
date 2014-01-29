/*!
 * https://gist.github.com/JeffJacobson/2770509
 * https://gist.github.com/smilekzs/8683955
 * Licensed under The MIT License
 */

/**
* Converts a value to a string appropriate for entry into a CSV table.  E.g., a string value will be surrounded by quotes.
* @param {string|number|object} theValue
*/
function toCsvValue(theValue) {
    var t = typeof (theValue), output;
 
    if (t === "undefined" || t === null) {
        output = "";
    } else {
        output = '"' + theValue.toString().replace(/"/g, '""') + '"';
    }
 
    return output;
}
 
/**
* Converts an array of objects (with identical schemas) into a CSV table.
* @param {Array} objArray An array of objects.  Each object in the array must have the same property list.
* @return {string} The CSV equivalent of objArray.
*/
function toCsv(objArray) {
    var i, l, names = [], name, value, obj, row, output = "", n, nl;
 
    for (i = 0, l = objArray.length; i < l; i += 1) {
        // Get the names of the properties.
        obj = objArray[i];
        row = "";
        if (i === 0) {
            // Loop through the names
            for (name in obj) {
                if (obj.hasOwnProperty(name)) {
                    names.push(name);
                    row += ['"', name, '"', ","].join("");
                }
            }
            row = row.substring(0, row.length - 1);
            output += row;
        }
 
        output += "\n";
        row = "";
        for (n = 0, nl = names.length; n < nl; n += 1) {
            name = names[n];
            value = obj[name];
            if (n > 0) {
                row += ","
            }
            row += toCsvValue(value, '"');
        }
        output += row;
    }
 
    return output;
}

