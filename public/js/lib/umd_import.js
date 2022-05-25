const umdImport = async function (url, module = {exports:{}}) {
    const response = await fetch(url)
    const script = await response.text()
    const func = Function("module", "exports", script)
    func.call(module, module, module.exports)
    return module.exports
};

export default umdImport
