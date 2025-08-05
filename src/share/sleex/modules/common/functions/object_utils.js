function toPlainObject(qtObj) {
    if (qtObj === null || typeof qtObj !== "object") return qtObj;

<<<<<<< HEAD
    // Handle true arrays
    if (Array.isArray(qtObj)) {
        return qtObj.map(item => toPlainObject(item));
    }

    // Handle array-like Qt objects (e.g., have length and numeric keys)
    if (
        typeof qtObj.length === "number" &&
        qtObj.length > 0 &&
        Object.keys(qtObj).every(
            key => !isNaN(key) || key === "length"
        )
    ) {
        let arr = [];
        for (let i = 0; i < qtObj.length; i++) {
            arr.push(toPlainObject(qtObj[i]));
        }
        return arr;
=======
    // Handle arrays
    if (Array.isArray(qtObj)) {
        return qtObj.map(toPlainObject);
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    }

    const result = ({});
    for (let key in qtObj) {
        if (
            typeof qtObj[key] !== "function" &&
            !key.startsWith("objectName") &&
            !key.startsWith("children") &&
            !key.startsWith("object") &&
            !key.startsWith("parent") &&
            !key.startsWith("metaObject") &&
            !key.startsWith("destroyed") &&
            !key.startsWith("reloadableId")
        ) {
            result[key] = toPlainObject(qtObj[key]);
        }
    }
<<<<<<< HEAD
    // console.log(JSON.stringify(result))
=======
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
    return result;
}

function applyToQtObject(qtObj, jsonObj) {
<<<<<<< HEAD
    // console.log("applyToQtObject", JSON.stringify(qtObj, null, 2), "<<", JSON.stringify(jsonObj, null, 2));
    if (!qtObj || typeof jsonObj !== "object" || jsonObj === null) return;

    // Detect array-like Qt objects
    const isQtArrayLike = obj => {
        return obj && typeof obj === "object" &&
            typeof obj.length === "number" &&
            obj.length > 0 &&
            Object.keys(obj).every(key => !isNaN(key) || key === "length");
    };

    // If both are arrays or array-like, update in place or replace
    if ((Array.isArray(qtObj) || isQtArrayLike(qtObj)) && Array.isArray(jsonObj)) {
        qtObj.length = 0;
        for (let i = 0; i < jsonObj.length; i++) {
            qtObj.push(jsonObj[i]);
        }
        return;
    }

    // If target is array or array-like but source is not, clear
    if ((Array.isArray(qtObj) || isQtArrayLike(qtObj)) && !Array.isArray(jsonObj)) {
        qtObj.length = 0;
        return;
    }

    // If source is array but target is not, assign directly if possible
    if (!(Array.isArray(qtObj) || isQtArrayLike(qtObj)) && Array.isArray(jsonObj)) {
        return jsonObj;
    }

    for (let key in jsonObj) {
        if (!qtObj.hasOwnProperty(key)) continue;
        const value = qtObj[key];
        const jsonValue = jsonObj[key];
        // console.log("applying to qt obj key:", value, "jsonValue:", jsonValue);
        if ((Array.isArray(value) || isQtArrayLike(value)) && Array.isArray(jsonValue)) {
            value.length = 0;
            for (let i = 0; i < jsonValue.length; i++) {
                value.push(jsonValue[i]);
            }
        } else if (value && typeof value === "object" && !Array.isArray(value) && !isQtArrayLike(value)) {
            applyToQtObject(value, jsonValue);
        } else {
            qtObj[key] = jsonValue;
        }
    }
}
=======
    if (!qtObj || typeof jsonObj !== "object" || jsonObj === null) return;

    for (let key in jsonObj) {
        if (!qtObj.hasOwnProperty(key)) continue;

        // Check if the property is a QtObject (not a value)
        const value = qtObj[key];
        const jsonValue = jsonObj[key];

        // If it's an object and not an array, recurse
        if (value && typeof value === "object" && !Array.isArray(value)) {
            applyToQtObject(value, jsonValue);
        } else {
            // Otherwise, assign the value
            qtObj[key] = jsonValue;
        }
    }
}
>>>>>>> fa28d8f (Initial commit of the quickshell migration)
