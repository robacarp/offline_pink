const deepMerge = function(...list) {
    return list.reduce(
        (a,b) => {
            // for non objects return b if exists or a
            if ( ! ( a instanceof Object ) || ! ( b instanceof Object ) ) {
                return b !== undefined ? b : a;
            }
            // for objects, get the keys and combine them
            const keys = Object.keys(a).concat(Object.keys(b));
            return keys.map(
                key => {
                    return  {[key]: deepMerge(a[key],b[key])}
                }
            ).reduce(
                (x,y) => {
                    return {...x,...y}
                }
            );
        }
    )
}

export default deepMerge
