def can_build(env, platform):
    env.module_add_dependencies("lescript", ["jsonrpc", "websocket"], True)
    return True


def configure(env):
    pass


def get_doc_classes():
    return [
        "@LEScript",
        "LEScript",
        "LEScriptLanguageProtocol",
        "LEScriptSyntaxHighlighter",
        "LEScriptTextDocument",
        "LEScriptWorkspace",
    ]


def get_doc_path():
    return "doc_classes"
