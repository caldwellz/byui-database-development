/* PrismJS 1.14.0
https://prismjs.com/download.html#themes=prism-tomorrow&languages=markup+css+clike+javascript+c+csharp+bash+cpp+aspnet+markup-templating+java+json+kotlin+lisp+php+sql+powershell+python+r+typescript+scss+plsql&plugins=autoloader+normalize-whitespace */
var _self = 'undefined' != typeof window ? window : 'undefined' != typeof WorkerGlobalScope && self instanceof WorkerGlobalScope ? self : {},
    Prism = function () {
        var e = /\blang(?:uage)?-([\w-]+)\b/i,
            t = 0,
            n = _self.Prism = {
                manual: _self.Prism && _self.Prism.manual,
                disableWorkerMessageHandler: _self.Prism && _self.Prism.disableWorkerMessageHandler,
                util: {
                    encode: function (e) {
                        return e instanceof r ? new r(e.type, n.util.encode(e.content), e.alias) : 'Array' === n.util.type(e) ? e.map(n.util.encode) : e.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/\u00a0/g, ' ');
                    },
                    type: function (e) {
                        return Object.prototype.toString.call(e).match(/\[object (\w+)\]/)[1];
                    },
                    objId: function (e) {
                        return e.__id || Object.defineProperty(e, '__id', {
                            value: ++t
                        }), e.__id;
                    },
                    clone: function (e, t) {
                        var r = n.util.type(e);
                        switch (t = t || {}, r) {
                        case 'Object':
                            if (t[n.util.objId(e)]) return t[n.util.objId(e)];
                            var a = {};
                            t[n.util.objId(e)] = a;
                            for (var l in e) e.hasOwnProperty(l) && (a[l] = n.util.clone(e[l], t));
                            return a;
                        case 'Array':
                            if (t[n.util.objId(e)]) return t[n.util.objId(e)];
                            var a = [];
                            return t[n.util.objId(e)] = a, e.forEach(function (e, r) {
                                a[r] = n.util.clone(e, t);
                            }), a;
                        }
                        return e;
                    }
                },
                languages: {
                    extend: function (e, t) {
                        var r = n.util.clone(n.languages[e]);
                        for (var a in t) r[a] = t[a];
                        return r;
                    },
                    insertBefore: function (e, t, r, a) {
                        a = a || n.languages;
                        var l = a[e];
                        if (2 == arguments.length) {
                            r = arguments[1];
                            for (var i in r) r.hasOwnProperty(i) && (l[i] = r[i]);
                            return l;
                        }
                        var o = {};
                        for (var s in l)
                            if (l.hasOwnProperty(s)) {
                                if (s == t)
                                    for (var i in r) r.hasOwnProperty(i) && (o[i] = r[i]);
                                o[s] = l[s];
                            } return n.languages.DFS(n.languages, function (t, n) {
                            n === a[e] && t != e && (this[t] = o);
                        }), a[e] = o;
                    },
                    DFS: function (e, t, r, a) {
                        a = a || {};
                        for (var l in e) e.hasOwnProperty(l) && (t.call(e, l, e[l], r || l), 'Object' !== n.util.type(e[l]) || a[n.util.objId(e[l])] ? 'Array' !== n.util.type(e[l]) || a[n.util.objId(e[l])] || (a[n.util.objId(e[l])] = !0, n.languages.DFS(e[l], t, l, a)) : (a[n.util.objId(e[l])] = !0, n.languages.DFS(e[l], t, null, a)));
                    }
                },
                plugins: {},
                highlightAll: function (e, t) {
                    n.highlightAllUnder(document, e, t);
                },
                highlightAllUnder: function (e, t, r) {
                    var a = {
                        callback: r,
                        selector: 'code[class*="language-"], [class*="language-"] code, code[class*="lang-"], [class*="lang-"] code'
                    };
                    n.hooks.run('before-highlightall', a);
                    for (var l, i = a.elements || e.querySelectorAll(a.selector), o = 0; l = i[o++];) n.highlightElement(l, t === !0, a.callback);
                },
                highlightElement: function (t, r, a) {
                    for (var l, i, o = t; o && !e.test(o.className);) o = o.parentNode;
                    o && (l = (o.className.match(e) || [, ''])[1].toLowerCase(), i = n.languages[l]), t.className = t.className.replace(e, '').replace(/\s+/g, ' ') + ' language-' + l, t.parentNode && (o = t.parentNode, /pre/i.test(o.nodeName) && (o.className = o.className.replace(e, '').replace(/\s+/g, ' ') + ' language-' + l));
                    var s = t.textContent,
                        u = {
                            element: t,
                            language: l,
                            grammar: i,
                            code: s
                        };
                    if (n.hooks.run('before-sanity-check', u), !u.code || !u.grammar) return u.code && (n.hooks.run('before-highlight', u), u.element.textContent = u.code, n.hooks.run('after-highlight', u)), n.hooks.run('complete', u), void 0;
                    if (n.hooks.run('before-highlight', u), r && _self.Worker) {
                        var g = new Worker(n.filename);
                        g.onmessage = function (e) {
                            u.highlightedCode = e.data, n.hooks.run('before-insert', u), u.element.innerHTML = u.highlightedCode, a && a.call(u.element), n.hooks.run('after-highlight', u), n.hooks.run('complete', u);
                        }, g.postMessage(JSON.stringify({
                            language: u.language,
                            code: u.code,
                            immediateClose: !0
                        }));
                    } else u.highlightedCode = n.highlight(u.code, u.grammar, u.language), n.hooks.run('before-insert', u), u.element.innerHTML = u.highlightedCode, a && a.call(t), n.hooks.run('after-highlight', u), n.hooks.run('complete', u);
                },
                highlight: function (e, t, a) {
                    var l = {
                        code: e,
                        grammar: t,
                        language: a
                    };
                    return n.hooks.run('before-tokenize', l), l.tokens = n.tokenize(l.code, l.grammar), n.hooks.run('after-tokenize', l), r.stringify(n.util.encode(l.tokens), l.language);
                },
                matchGrammar: function (e, t, r, a, l, i, o) {
                    var s = n.Token;
                    for (var u in r)
                        if (r.hasOwnProperty(u) && r[u]) {
                            if (u == o) return;
                            var g = r[u];
                            g = 'Array' === n.util.type(g) ? g : [g];
                            for (var c = 0; c < g.length; ++c) {
                                var h = g[c],
                                    f = h.inside,
                                    d = !!h.lookbehind,
                                    m = !!h.greedy,
                                    p = 0,
                                    y = h.alias;
                                if (m && !h.pattern.global) {
                                    var v = h.pattern.toString().match(/[imuy]*$/)[0];
                                    h.pattern = RegExp(h.pattern.source, v + 'g');
                                }
                                h = h.pattern || h;
                                for (var b = a, k = l; b < t.length; k += t[b].length, ++b) {
                                    var w = t[b];
                                    if (t.length > e.length) return;
                                    if (!(w instanceof s)) {
                                        if (m && b != t.length - 1) {
                                            h.lastIndex = k;
                                            var _ = h.exec(e);
                                            if (!_) break;
                                            for (var j = _.index + (d ? _[1].length : 0), P = _.index + _[0].length, A = b, x = k, O = t.length; O > A && (P > x || !t[A].type && !t[A - 1].greedy); ++A) x += t[A].length, j >= x && (++b, k = x);
                                            if (t[b] instanceof s) continue;
                                            I = A - b, w = e.slice(k, x), _.index -= k;
                                        } else {
                                            h.lastIndex = 0;
                                            var _ = h.exec(w),
                                                I = 1;
                                        }
                                        if (_) {
                                            d && (p = _[1] ? _[1].length : 0);
                                            var j = _.index + p,
                                                _ = _[0].slice(p),
                                                P = j + _.length,
                                                N = w.slice(0, j),
                                                S = w.slice(P),
                                                C = [b, I];
                                            N && (++b, k += N.length, C.push(N));
                                            var E = new s(u, f ? n.tokenize(_, f) : _, y, _, m);
                                            if (C.push(E), S && C.push(S), Array.prototype.splice.apply(t, C), 1 != I && n.matchGrammar(e, t, r, b, k, !0, u), i) break;
                                        } else if (i) break;
                                    }
                                }
                            }
                        }
                },
                tokenize: function (e, t) {
                    var r = [e],
                        a = t.rest;
                    if (a) {
                        for (var l in a) t[l] = a[l];
                        delete t.rest;
                    }
                    return n.matchGrammar(e, r, t, 0, 0, !1), r;
                },
                hooks: {
                    all: {},
                    add: function (e, t) {
                        var r = n.hooks.all;
                        r[e] = r[e] || [], r[e].push(t);
                    },
                    run: function (e, t) {
                        var r = n.hooks.all[e];
                        if (r && r.length)
                            for (var a, l = 0; a = r[l++];) a(t);
                    }
                }
            },
            r = n.Token = function (e, t, n, r, a) {
                this.type = e, this.content = t, this.alias = n, this.length = 0 | (r || '').length, this.greedy = !!a;
            };
        if (r.stringify = function (e, t, a) {
            if ('string' == typeof e) return e;
            if ('Array' === n.util.type(e)) return e.map(function (n) {
                return r.stringify(n, t, e);
            }).join('');
            var l = {
                type: e.type,
                content: r.stringify(e.content, t, a),
                tag: 'span',
                classes: ['token', e.type],
                attributes: {},
                language: t,
                parent: a
            };
            if (e.alias) {
                var i = 'Array' === n.util.type(e.alias) ? e.alias : [e.alias];
                Array.prototype.push.apply(l.classes, i);
            }
            n.hooks.run('wrap', l);
            var o = Object.keys(l.attributes).map(function (e) {
                return e + '="' + (l.attributes[e] || '').replace(/"/g, '&quot;') + '"';
            }).join(' ');
            return '<' + l.tag + ' class="' + l.classes.join(' ') + '"' + (o ? ' ' + o : '') + '>' + l.content + '</' + l.tag + '>';
        }, !_self.document) return _self.addEventListener ? (n.disableWorkerMessageHandler || _self.addEventListener('message', function (e) {
            var t = JSON.parse(e.data),
                r = t.language,
                a = t.code,
                l = t.immediateClose;
            _self.postMessage(n.highlight(a, n.languages[r], r)), l && _self.close();
        }, !1), _self.Prism) : _self.Prism;
        var a = document.currentScript || [].slice.call(document.getElementsByTagName('script')).pop();
        return a && (n.filename = a.src, n.manual || a.hasAttribute('data-manual') || ('loading' !== document.readyState ? window.requestAnimationFrame ? window.requestAnimationFrame(n.highlightAll) : window.setTimeout(n.highlightAll, 16) : document.addEventListener('DOMContentLoaded', n.highlightAll))), _self.Prism;
    }();
'undefined' != typeof module && module.exports && (module.exports = Prism), 'undefined' != typeof global && (global.Prism = Prism);
Prism.languages.markup = {
    comment: /<!--[\s\S]*?-->/,
    prolog: /<\?[\s\S]+?\?>/,
    doctype: /<!DOCTYPE[\s\S]+?>/i,
    cdata: /<!\[CDATA\[[\s\S]*?]]>/i,
    tag: {
        pattern: /<\/?(?!\d)[^\s>\/=$<%]+(?:\s+[^\s>\/=]+(?:=(?:("|')(?:\\[\s\S]|(?!\1)[^\\])*\1|[^\s'">=]+))?)*\s*\/?>/i,
        greedy: !0,
        inside: {
            tag: {
                pattern: /^<\/?[^\s>\/]+/i,
                inside: {
                    punctuation: /^<\/?/,
                    namespace: /^[^\s>\/:]+:/
                }
            },
            'attr-value': {
                pattern: /=(?:("|')(?:\\[\s\S]|(?!\1)[^\\])*\1|[^\s'">=]+)/i,
                inside: {
                    punctuation: [/^=/, {
                        pattern: /(^|[^\\])["']/,
                        lookbehind: !0
                    }]
                }
            },
            punctuation: /\/?>/,
            'attr-name': {
                pattern: /[^\s>\/]+/,
                inside: {
                    namespace: /^[^\s>\/:]+:/
                }
            }
        }
    },
    entity: /&#?[\da-z]{1,8};/i
}, Prism.languages.markup.tag.inside['attr-value'].inside.entity = Prism.languages.markup.entity, Prism.hooks.add('wrap', function (a) {
    'entity' === a.type && (a.attributes.title = a.content.replace(/&amp;/, '&'));
}), Prism.languages.xml = Prism.languages.markup, Prism.languages.html = Prism.languages.markup, Prism.languages.mathml = Prism.languages.markup, Prism.languages.svg = Prism.languages.markup;
Prism.languages.css = {
    comment: /\/\*[\s\S]*?\*\//,
    atrule: {
        pattern: /@[\w-]+?.*?(?:;|(?=\s*\{))/i,
        inside: {
            rule: /@[\w-]+/
        }
    },
    url: /url\((?:(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1|.*?)\)/i,
    selector: /[^{}\s][^{};]*?(?=\s*\{)/,
    string: {
        pattern: /("|')(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,
        greedy: !0
    },
    property: /[-_a-z\xA0-\uFFFF][-\w\xA0-\uFFFF]*(?=\s*:)/i,
    important: /\B!important\b/i,
    'function': /[-a-z0-9]+(?=\()/i,
    punctuation: /[(){};:]/
}, Prism.languages.css.atrule.inside.rest = Prism.languages.css, Prism.languages.markup && (Prism.languages.insertBefore('markup', 'tag', {
    style: {
        pattern: /(<style[\s\S]*?>)[\s\S]*?(?=<\/style>)/i,
        lookbehind: !0,
        inside: Prism.languages.css,
        alias: 'language-css',
        greedy: !0
    }
}), Prism.languages.insertBefore('inside', 'attr-value', {
        'style-attr': {
            pattern: /\s*style=("|')(?:\\[\s\S]|(?!\1)[^\\])*\1/i,
            inside: {
                'attr-name': {
                    pattern: /^\s*style/i,
                    inside: Prism.languages.markup.tag.inside
                },
                punctuation: /^\s*=\s*['"]|['"]\s*$/,
                'attr-value': {
                    pattern: /.+/i,
                    inside: Prism.languages.css
                }
            },
            alias: 'language-css'
        }
    }, Prism.languages.markup.tag));
Prism.languages.clike = {
    comment: [{
        pattern: /(^|[^\\])\/\*[\s\S]*?(?:\*\/|$)/,
        lookbehind: !0
    }, {
        pattern: /(^|[^\\:])\/\/.*/,
        lookbehind: !0,
        greedy: !0
    }],
    string: {
        pattern: /(["'])(?:\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,
        greedy: !0
    },
    'class-name': {
        pattern: /((?:\b(?:class|interface|extends|implements|trait|instanceof|new)\s+)|(?:catch\s+\())[\w.\\]+/i,
        lookbehind: !0,
        inside: {
            punctuation: /[.\\]/
        }
    },
    keyword: /\b(?:if|else|while|do|for|return|in|instanceof|function|new|try|throw|catch|finally|null|break|continue)\b/,
    'boolean': /\b(?:true|false)\b/,
    'function': /[a-z0-9_]+(?=\()/i,
    number: /\b0x[\da-f]+\b|(?:\b\d+\.?\d*|\B\.\d+)(?:e[+-]?\d+)?/i,
    operator: /--?|\+\+?|!=?=?|<=?|>=?|==?=?|&&?|\|\|?|\?|\*|\/|~|\^|%/,
    punctuation: /[{}[\];(),.:]/
};
Prism.languages.javascript = Prism.languages.extend('clike', {
    keyword: /\b(?:as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield)\b/,
    number: /\b(?:0[xX][\dA-Fa-f]+|0[bB][01]+|0[oO][0-7]+|NaN|Infinity)\b|(?:\b\d+\.?\d*|\B\.\d+)(?:[Ee][+-]?\d+)?/,
    'function': /[_$a-z\xA0-\uFFFF][$\w\xA0-\uFFFF]*(?=\s*\()/i,
    operator: /-[-=]?|\+[+=]?|!=?=?|<<?=?|>>?>?=?|=(?:==?|>)?|&[&=]?|\|[|=]?|\*\*?=?|\/=?|~|\^=?|%=?|\?|\.{3}/
}), Prism.languages.insertBefore('javascript', 'keyword', {
    regex: {
        pattern: /((?:^|[^$\w\xA0-\uFFFF."'\])\s])\s*)\/(\[[^\]\r\n]+]|\\.|[^\/\\\[\r\n])+\/[gimyu]{0,5}(?=\s*($|[\r\n,.;})\]]))/,
        lookbehind: !0,
        greedy: !0
    },
    'function-variable': {
        pattern: /[_$a-z\xA0-\uFFFF][$\w\xA0-\uFFFF]*(?=\s*=\s*(?:function\b|(?:\([^()]*\)|[_$a-z\xA0-\uFFFF][$\w\xA0-\uFFFF]*)\s*=>))/i,
        alias: 'function'
    },
    constant: /\b[A-Z][A-Z\d_]*\b/
}), Prism.languages.insertBefore('javascript', 'string', {
    'template-string': {
        pattern: /`(?:\\[\s\S]|\${[^}]+}|[^\\`])*`/,
        greedy: !0,
        inside: {
            interpolation: {
                pattern: /\${[^}]+}/,
                inside: {
                    'interpolation-punctuation': {
                        pattern: /^\${|}$/,
                        alias: 'punctuation'
                    },
                    rest: null
                }
            },
            string: /[\s\S]+/
        }
    }
}), Prism.languages.javascript['template-string'].inside.interpolation.inside.rest = Prism.languages.javascript, Prism.languages.markup && Prism.languages.insertBefore('markup', 'tag', {
    script: {
        pattern: /(<script[\s\S]*?>)[\s\S]*?(?=<\/script>)/i,
        lookbehind: !0,
        inside: Prism.languages.javascript,
        alias: 'language-javascript',
        greedy: !0
    }
}), Prism.languages.js = Prism.languages.javascript;
Prism.languages.c = Prism.languages.extend('clike', {
    keyword: /\b(?:_Alignas|_Alignof|_Atomic|_Bool|_Complex|_Generic|_Imaginary|_Noreturn|_Static_assert|_Thread_local|asm|typeof|inline|auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while)\b/,
    operator: /-[>-]?|\+\+?|!=?|<<?=?|>>?=?|==?|&&?|\|\|?|[~^%?*\/]/,
    number: /(?:\b0x[\da-f]+|(?:\b\d+\.?\d*|\B\.\d+)(?:e[+-]?\d+)?)[ful]*/i
}), Prism.languages.insertBefore('c', 'string', {
    macro: {
        pattern: /(^\s*)#\s*[a-z]+(?:[^\r\n\\]|\\(?:\r\n|[\s\S]))*/im,
        lookbehind: !0,
        alias: 'property',
        inside: {
            string: {
                pattern: /(#\s*include\s*)(?:<.+?>|("|')(?:\\?.)+?\2)/,
                lookbehind: !0
            },
            directive: {
                pattern: /(#\s*)\b(?:define|defined|elif|else|endif|error|ifdef|ifndef|if|import|include|line|pragma|undef|using)\b/,
                lookbehind: !0,
                alias: 'keyword'
            }
        }
    },
    constant: /\b(?:__FILE__|__LINE__|__DATE__|__TIME__|__TIMESTAMP__|__func__|EOF|NULL|SEEK_CUR|SEEK_END|SEEK_SET|stdin|stdout|stderr)\b/
}), delete Prism.languages.c['class-name'], delete Prism.languages.c['boolean'];
Prism.languages.csharp = Prism.languages.extend('clike', {
    keyword: /\b(?:abstract|add|alias|as|ascending|async|await|base|bool|break|byte|case|catch|char|checked|class|const|continue|decimal|default|delegate|descending|do|double|dynamic|else|enum|event|explicit|extern|false|finally|fixed|float|for|foreach|from|get|global|goto|group|if|implicit|in|int|interface|internal|into|is|join|let|lock|long|namespace|new|null|object|operator|orderby|out|override|params|partial|private|protected|public|readonly|ref|remove|return|sbyte|sealed|select|set|short|sizeof|stackalloc|static|string|struct|switch|this|throw|true|try|typeof|uint|ulong|unchecked|unsafe|ushort|using|value|var|virtual|void|volatile|where|while|yield)\b/,
    string: [{
        pattern: /@("|')(?:\1\1|\\[\s\S]|(?!\1)[^\\])*\1/,
        greedy: !0
    }, {
        pattern: /("|')(?:\\.|(?!\1)[^\\\r\n])*?\1/,
        greedy: !0
    }],
    'class-name': [{
        pattern: /\b[A-Z]\w*(?:\.\w+)*\b(?=\s+\w+)/,
        inside: {
            punctuation: /\./
        }
    }, {
        pattern: /(\[)[A-Z]\w*(?:\.\w+)*\b/,
        lookbehind: !0,
        inside: {
            punctuation: /\./
        }
    }, {
        pattern: /(\b(?:class|interface)\s+[A-Z]\w*(?:\.\w+)*\s*:\s*)[A-Z]\w*(?:\.\w+)*\b/,
        lookbehind: !0,
        inside: {
            punctuation: /\./
        }
    }, {
        pattern: /((?:\b(?:class|interface|new)\s+)|(?:catch\s+\())[A-Z]\w*(?:\.\w+)*\b/,
        lookbehind: !0,
        inside: {
            punctuation: /\./
        }
    }],
    number: /\b0x[\da-f]+\b|(?:\b\d+\.?\d*|\B\.\d+)f?/i
}), Prism.languages.insertBefore('csharp', 'class-name', {
    'generic-method': {
        pattern: /\w+\s*<[^>\r\n]+?>\s*(?=\()/,
        inside: {
            'function': /^\w+/,
            'class-name': {
                pattern: /\b[A-Z]\w*(?:\.\w+)*\b/,
                inside: {
                    punctuation: /\./
                }
            },
            keyword: Prism.languages.csharp.keyword,
            punctuation: /[<>(),.:]/
        }
    },
    preprocessor: {
        pattern: /(^\s*)#.*/m,
        lookbehind: !0,
        alias: 'property',
        inside: {
            directive: {
                pattern: /(\s*#)\b(?:define|elif|else|endif|endregion|error|if|line|pragma|region|undef|warning)\b/,
                lookbehind: !0,
                alias: 'keyword'
            }
        }
    }
}), Prism.languages.dotnet = Prism.languages.csharp;
! function (e) {
    var t = {
        variable: [{
            pattern: /\$?\(\([\s\S]+?\)\)/,
            inside: {
                variable: [{
                    pattern: /(^\$\(\([\s\S]+)\)\)/,
                    lookbehind: !0
                }, /^\$\(\(/],
                number: /\b0x[\dA-Fa-f]+\b|(?:\b\d+\.?\d*|\B\.\d+)(?:[Ee]-?\d+)?/,
                operator: /--?|-=|\+\+?|\+=|!=?|~|\*\*?|\*=|\/=?|%=?|<<=?|>>=?|<=?|>=?|==?|&&?|&=|\^=?|\|\|?|\|=|\?|:/,
                punctuation: /\(\(?|\)\)?|,|;/
            }
        }, {
            pattern: /\$\([^)]+\)|`[^`]+`/,
            greedy: !0,
            inside: {
                variable: /^\$\(|^`|\)$|`$/
            }
        }, /\$(?:[\w#?*!@]+|\{[^}]+\})/i]
    };
    e.languages.bash = {
        shebang: {
            pattern: /^#!\s*\/bin\/bash|^#!\s*\/bin\/sh/,
            alias: 'important'
        },
        comment: {
            pattern: /(^|[^"{\\])#.*/,
            lookbehind: !0
        },
        string: [{
            pattern: /((?:^|[^<])<<\s*)["']?(\w+?)["']?\s*\r?\n(?:[\s\S])*?\r?\n\2/,
            lookbehind: !0,
            greedy: !0,
            inside: t
        }, {
            pattern: /(["'])(?:\\[\s\S]|\$\([^)]+\)|`[^`]+`|(?!\1)[^\\])*\1/,
            greedy: !0,
            inside: t
        }],
        variable: t.variable,
        'function': {
            pattern: /(^|[\s;|&])(?:alias|apropos|apt-get|aptitude|aspell|awk|basename|bash|bc|bg|builtin|bzip2|cal|cat|cd|cfdisk|chgrp|chmod|chown|chroot|chkconfig|cksum|clear|cmp|comm|command|cp|cron|crontab|csplit|curl|cut|date|dc|dd|ddrescue|df|diff|diff3|dig|dir|dircolors|dirname|dirs|dmesg|du|egrep|eject|enable|env|ethtool|eval|exec|expand|expect|export|expr|fdformat|fdisk|fg|fgrep|file|find|fmt|fold|format|free|fsck|ftp|fuser|gawk|getopts|git|grep|groupadd|groupdel|groupmod|groups|gzip|hash|head|help|hg|history|hostname|htop|iconv|id|ifconfig|ifdown|ifup|import|install|jobs|join|kill|killall|less|link|ln|locate|logname|logout|look|lpc|lpr|lprint|lprintd|lprintq|lprm|ls|lsof|make|man|mkdir|mkfifo|mkisofs|mknod|more|most|mount|mtools|mtr|mv|mmv|nano|netstat|nice|nl|nohup|notify-send|npm|nslookup|open|op|passwd|paste|pathchk|ping|pkill|popd|pr|printcap|printenv|printf|ps|pushd|pv|pwd|quota|quotacheck|quotactl|ram|rar|rcp|read|readarray|readonly|reboot|rename|renice|remsync|rev|rm|rmdir|rsync|screen|scp|sdiff|sed|seq|service|sftp|shift|shopt|shutdown|sleep|slocate|sort|source|split|ssh|stat|strace|su|sudo|sum|suspend|sync|tail|tar|tee|test|time|timeout|times|touch|top|traceroute|trap|tr|tsort|tty|type|ulimit|umask|umount|unalias|uname|unexpand|uniq|units|unrar|unshar|uptime|useradd|userdel|usermod|users|uuencode|uudecode|v|vdir|vi|vmstat|wait|watch|wc|wget|whereis|which|who|whoami|write|xargs|xdg-open|yes|zip)(?=$|[\s;|&])/,
            lookbehind: !0
        },
        keyword: {
            pattern: /(^|[\s;|&])(?:let|:|\.|if|then|else|elif|fi|for|break|continue|while|in|case|function|select|do|done|until|echo|exit|return|set|declare)(?=$|[\s;|&])/,
            lookbehind: !0
        },
        'boolean': {
            pattern: /(^|[\s;|&])(?:true|false)(?=$|[\s;|&])/,
            lookbehind: !0
        },
        operator: /&&?|\|\|?|==?|!=?|<<<?|>>|<=?|>=?|=~/,
        punctuation: /\$?\(\(?|\)\)?|\.\.|[{}[\];]/
    };
    var a = t.variable[1].inside;
    a.string = e.languages.bash.string, a['function'] = e.languages.bash['function'], a.keyword = e.languages.bash.keyword, a['boolean'] = e.languages.bash['boolean'], a.operator = e.languages.bash.operator, a.punctuation = e.languages.bash.punctuation, e.languages.shell = e.languages.bash;
}(Prism);
Prism.languages.cpp = Prism.languages.extend('c', {
    keyword: /\b(?:alignas|alignof|asm|auto|bool|break|case|catch|char|char16_t|char32_t|class|compl|const|constexpr|const_cast|continue|decltype|default|delete|do|double|dynamic_cast|else|enum|explicit|export|extern|float|for|friend|goto|if|inline|int|int8_t|int16_t|int32_t|int64_t|uint8_t|uint16_t|uint32_t|uint64_t|long|mutable|namespace|new|noexcept|nullptr|operator|private|protected|public|register|reinterpret_cast|return|short|signed|sizeof|static|static_assert|static_cast|struct|switch|template|this|thread_local|throw|try|typedef|typeid|typename|union|unsigned|using|virtual|void|volatile|wchar_t|while)\b/,
    'boolean': /\b(?:true|false)\b/,
    operator: /--?|\+\+?|!=?|<{1,2}=?|>{1,2}=?|->|:{1,2}|={1,2}|\^|~|%|&{1,2}|\|\|?|\?|\*|\/|\b(?:and|and_eq|bitand|bitor|not|not_eq|or|or_eq|xor|xor_eq)\b/
}), Prism.languages.insertBefore('cpp', 'keyword', {
    'class-name': {
        pattern: /(class\s+)\w+/i,
        lookbehind: !0
    }
}), Prism.languages.insertBefore('cpp', 'string', {
    'raw-string': {
        pattern: /R"([^()\\ ]{0,16})\([\s\S]*?\)\1"/,
        alias: 'string',
        greedy: !0
    }
});
Prism.languages.aspnet = Prism.languages.extend('markup', {
    'page-directive tag': {
        pattern: /<%\s*@.*%>/i,
        inside: {
            'page-directive tag': /<%\s*@\s*(?:Assembly|Control|Implements|Import|Master(?:Type)?|OutputCache|Page|PreviousPageType|Reference|Register)?|%>/i,
            rest: Prism.languages.markup.tag.inside
        }
    },
    'directive tag': {
        pattern: /<%.*%>/i,
        inside: {
            'directive tag': /<%\s*?[$=%#:]{0,2}|%>/i,
            rest: Prism.languages.csharp
        }
    }
}), Prism.languages.aspnet.tag.pattern = /<(?!%)\/?[^\s>\/]+(?:\s+[^\s>\/=]+(?:=(?:("|')(?:\\[\s\S]|(?!\1)[^\\])*\1|[^\s'">=]+))?)*\s*\/?>/i, Prism.languages.insertBefore('inside', 'punctuation', {
    'directive tag': Prism.languages.aspnet['directive tag']
}, Prism.languages.aspnet.tag.inside['attr-value']), Prism.languages.insertBefore('aspnet', 'comment', {
    'asp comment': /<%--[\s\S]*?--%>/
}), Prism.languages.insertBefore('aspnet', Prism.languages.javascript ? 'script' : 'tag', {
    'asp script': {
        pattern: /(<script(?=.*runat=['"]?server['"]?)[\s\S]*?>)[\s\S]*?(?=<\/script>)/i,
        lookbehind: !0,
        inside: Prism.languages.csharp || {}
    }
});
Prism.languages['markup-templating'] = {}, Object.defineProperties(Prism.languages['markup-templating'], {
    buildPlaceholders: {
        value: function (e, t, n, a) {
            e.language === t && (e.tokenStack = [], e.code = e.code.replace(n, function (n) {
                if ('function' == typeof a && !a(n)) return n;
                for (var r = e.tokenStack.length; - 1 !== e.code.indexOf('___' + t.toUpperCase() + r + '___');) ++r;
                return e.tokenStack[r] = n, '___' + t.toUpperCase() + r + '___';
            }), e.grammar = Prism.languages.markup);
        }
    },
    tokenizePlaceholders: {
        value: function (e, t) {
            if (e.language === t && e.tokenStack) {
                e.grammar = Prism.languages[t];
                var n = 0,
                    a = Object.keys(e.tokenStack),
                    r = function (o) {
                        if (!(n >= a.length))
                            for (var i = 0; i < o.length; i++) {
                                var g = o[i];
                                if ('string' == typeof g || g.content && 'string' == typeof g.content) {
                                    var c = a[n],
                                        s = e.tokenStack[c],
                                        l = 'string' == typeof g ? g : g.content,
                                        p = l.indexOf('___' + t.toUpperCase() + c + '___');
                                    if (p > -1) {
                                        ++n;
                                        var f, u = l.substring(0, p),
                                            _ = new Prism.Token(t, Prism.tokenize(s, e.grammar, t), 'language-' + t, s),
                                            k = l.substring(p + ('___' + t.toUpperCase() + c + '___').length);
                                        if (u || k ? (f = [u, _, k].filter(function (e) {
                                            return !!e;
                                        }), r(f)) : f = _, 'string' == typeof g ? Array.prototype.splice.apply(o, [i, 1].concat(f)) : g.content = f, n >= a.length) break;
                                    }
                                } else g.content && 'string' != typeof g.content && r(g.content);
                            }
                    };
                r(e.tokens);
            }
        }
    }
});
Prism.languages.java = Prism.languages.extend('clike', {
    keyword: /\b(?:abstract|continue|for|new|switch|assert|default|goto|package|synchronized|boolean|do|if|private|this|break|double|implements|protected|throw|byte|else|import|public|throws|case|enum|instanceof|return|transient|catch|extends|int|short|try|char|final|interface|static|void|class|finally|long|strictfp|volatile|const|float|native|super|while)\b/,
    number: /\b0b[01]+\b|\b0x[\da-f]*\.?[\da-fp-]+\b|(?:\b\d+\.?\d*|\B\.\d+)(?:e[+-]?\d+)?[df]?/i,
    operator: {
        pattern: /(^|[^.])(?:\+[+=]?|-[-=]?|!=?|<<?=?|>>?>?=?|==?|&[&=]?|\|[|=]?|\*=?|\/=?|%=?|\^=?|[?:~])/m,
        lookbehind: !0
    }
}), Prism.languages.insertBefore('java', 'function', {
    annotation: {
        alias: 'punctuation',
        pattern: /(^|[^.])@\w+/,
        lookbehind: !0
    }
}), Prism.languages.insertBefore('java', 'class-name', {
    generics: {
        pattern: /<\s*\w+(?:\.\w+)?(?:\s*,\s*\w+(?:\.\w+)?)*>/i,
        alias: 'function',
        inside: {
            keyword: Prism.languages.java.keyword,
            punctuation: /[<>(),.:]/
        }
    }
});
Prism.languages.json = {
    property: /"(?:\\.|[^\\"\r\n])*"(?=\s*:)/i,
    string: {
        pattern: /"(?:\\.|[^\\"\r\n])*"(?!\s*:)/,
        greedy: !0
    },
    number: /\b0x[\dA-Fa-f]+\b|(?:\b\d+\.?\d*|\B\.\d+)(?:[Ee][+-]?\d+)?/,
    punctuation: /[{}[\]);,]/,
    operator: /:/g,
    'boolean': /\b(?:true|false)\b/i,
    'null': /\bnull\b/i
}, Prism.languages.jsonp = Prism.languages.json;
! function (e) {
    e.languages.kotlin = e.languages.extend('clike', {
        keyword: {
            pattern: /(^|[^.])\b(?:abstract|actual|annotation|as|break|by|catch|class|companion|const|constructor|continue|crossinline|data|do|dynamic|else|enum|expect|external|final|finally|for|fun|get|if|import|in|infix|init|inline|inner|interface|internal|is|lateinit|noinline|null|object|open|operator|out|override|package|private|protected|public|reified|return|sealed|set|super|suspend|tailrec|this|throw|try|typealias|val|var|vararg|when|where|while)\b/,
            lookbehind: !0
        },
        'function': [/\w+(?=\s*\()/, {
            pattern: /(\.)\w+(?=\s*\{)/,
            lookbehind: !0
        }],
        number: /\b(?:0[xX][\da-fA-F]+(?:_[\da-fA-F]+)*|0[bB][01]+(?:_[01]+)*|\d+(?:_\d+)*(?:\.\d+(?:_\d+)*)?(?:[eE][+-]?\d+(?:_\d+)*)?[fFL]?)\b/,
        operator: /\+[+=]?|-[-=>]?|==?=?|!(?:!|==?)?|[\/*%<>]=?|[?:]:?|\.\.|&&|\|\||\b(?:and|inv|or|shl|shr|ushr|xor)\b/
    }), delete e.languages.kotlin['class-name'], e.languages.insertBefore('kotlin', 'string', {
        'raw-string': {
            pattern: /("""|''')[\s\S]*?\1/,
            alias: 'string'
        }
    }), e.languages.insertBefore('kotlin', 'keyword', {
        annotation: {
            pattern: /\B@(?:\w+:)?(?:[A-Z]\w*|\[[^\]]+\])/,
            alias: 'builtin'
        }
    }), e.languages.insertBefore('kotlin', 'function', {
        label: {
            pattern: /\w+@|@\w+/,
            alias: 'symbol'
        }
    });
    var n = [{
        pattern: /\$\{[^}]+\}/,
        inside: {
            delimiter: {
                pattern: /^\$\{|\}$/,
                alias: 'variable'
            },
            rest: e.languages.kotlin
        }
    }, {
        pattern: /\$\w+/,
        alias: 'variable'
    }];
    e.languages.kotlin.string.inside = e.languages.kotlin['raw-string'].inside = {
        interpolation: n
    };
}(Prism);
! function (e) {
    function n(e) {
        return new RegExp('(\\()' + e + '(?=[\\s\\)])');
    }

    function a(e) {
        return new RegExp('([\\s([])' + e + '(?=[\\s)])');
    }
    var t = '[-+*/_~!@$%^=<>{}\\w]+',
        r = '&' + t,
        i = '(\\()',
        s = '(?=\\))',
        o = '(?=\\s)',
        l = {
            heading: {
                pattern: /;;;.*/,
                alias: ['comment', 'title']
            },
            comment: /;.*/,
            string: {
                pattern: /"(?:[^"\\]*|\\.)*"/,
                greedy: !0,
                inside: {
                    argument: /[-A-Z]+(?=[.,\s])/,
                    symbol: new RegExp('`' + t + '\'')
                }
            },
            'quoted-symbol': {
                pattern: new RegExp('#?\'' + t),
                alias: ['variable', 'symbol']
            },
            'lisp-property': {
                pattern: new RegExp(':' + t),
                alias: 'property'
            },
            splice: {
                pattern: new RegExp(',@?' + t),
                alias: ['symbol', 'variable']
            },
            keyword: [{
                pattern: new RegExp(i + '(?:(?:lexical-)?let\\*?|(?:cl-)?letf|if|when|while|unless|cons|cl-loop|and|or|not|cond|setq|error|message|null|require|provide|use-package)' + o),
                lookbehind: !0
            }, {
                pattern: new RegExp(i + '(?:for|do|collect|return|finally|append|concat|in|by)' + o),
                lookbehind: !0
            }],
            declare: {
                pattern: n('declare'),
                lookbehind: !0,
                alias: 'keyword'
            },
            interactive: {
                pattern: n('interactive'),
                lookbehind: !0,
                alias: 'keyword'
            },
            'boolean': {
                pattern: a('(?:t|nil)'),
                lookbehind: !0
            },
            number: {
                pattern: a('[-+]?\\d+(?:\\.\\d*)?'),
                lookbehind: !0
            },
            defvar: {
                pattern: new RegExp(i + 'def(?:var|const|custom|group)\\s+' + t),
                lookbehind: !0,
                inside: {
                    keyword: /^def[a-z]+/,
                    variable: new RegExp(t)
                }
            },
            defun: {
                pattern: new RegExp(i + '(?:cl-)?(?:defun\\*?|defmacro)\\s+' + t + '\\s+\\([\\s\\S]*?\\)'),
                lookbehind: !0,
                inside: {
                    keyword: /^(?:cl-)?def\S+/,
                    arguments: null,
                    'function': {
                        pattern: new RegExp('(^\\s)' + t),
                        lookbehind: !0
                    },
                    punctuation: /[()]/
                }
            },
            lambda: {
                pattern: new RegExp(i + 'lambda\\s+\\((?:&?' + t + '\\s*)*\\)'),
                lookbehind: !0,
                inside: {
                    keyword: /^lambda/,
                    arguments: null,
                    punctuation: /[()]/
                }
            },
            car: {
                pattern: new RegExp(i + t),
                lookbehind: !0
            },
            punctuation: [/(['`,]?\(|[)\[\]])/, {
                pattern: /(\s)\.(?=\s)/,
                lookbehind: !0
            }]
        },
        p = {
            'lisp-marker': new RegExp(r),
            rest: {
                argument: {
                    pattern: new RegExp(t),
                    alias: 'variable'
                },
                varform: {
                    pattern: new RegExp(i + t + '\\s+\\S[\\s\\S]*' + s),
                    lookbehind: !0,
                    inside: {
                        string: l.string,
                        'boolean': l.boolean,
                        number: l.number,
                        symbol: l.symbol,
                        punctuation: /[()]/
                    }
                }
            }
        },
        d = '\\S+(?:\\s+\\S+)*',
        u = {
            pattern: new RegExp(i + '[\\s\\S]*' + s),
            lookbehind: !0,
            inside: {
                'rest-vars': {
                    pattern: new RegExp('&(?:rest|body)\\s+' + d),
                    inside: p
                },
                'other-marker-vars': {
                    pattern: new RegExp('&(?:optional|aux)\\s+' + d),
                    inside: p
                },
                keys: {
                    pattern: new RegExp('&key\\s+' + d + '(?:\\s+&allow-other-keys)?'),
                    inside: p
                },
                argument: {
                    pattern: new RegExp(t),
                    alias: 'variable'
                },
                punctuation: /[()]/
            }
        };
    l.lambda.inside.arguments = u, l.defun.inside.arguments = e.util.clone(u), l.defun.inside.arguments.inside.sublist = u, e.languages.lisp = l, e.languages.elisp = l, e.languages.emacs = l, e.languages['emacs-lisp'] = l;
}(Prism);
! function (e) {
    e.languages.php = e.languages.extend('clike', {
        keyword: /\b(?:and|or|xor|array|as|break|case|cfunction|class|const|continue|declare|default|die|do|else|elseif|enddeclare|endfor|endforeach|endif|endswitch|endwhile|extends|for|foreach|function|include|include_once|global|if|new|return|static|switch|use|require|require_once|var|while|abstract|interface|public|implements|private|protected|parent|throw|null|echo|print|trait|namespace|final|yield|goto|instanceof|finally|try|catch)\b/i,
        constant: /\b[A-Z0-9_]{2,}\b/,
        comment: {
            pattern: /(^|[^\\])(?:\/\*[\s\S]*?\*\/|\/\/.*)/,
            lookbehind: !0
        }
    }), e.languages.insertBefore('php', 'string', {
        'shell-comment': {
            pattern: /(^|[^\\])#.*/,
            lookbehind: !0,
            alias: 'comment'
        }
    }), e.languages.insertBefore('php', 'keyword', {
        delimiter: {
            pattern: /\?>|<\?(?:php|=)?/i,
            alias: 'important'
        },
        variable: /\$+(?:\w+\b|(?={))/i,
        'package': {
            pattern: /(\\|namespace\s+|use\s+)[\w\\]+/,
            lookbehind: !0,
            inside: {
                punctuation: /\\/
            }
        }
    }), e.languages.insertBefore('php', 'operator', {
        property: {
            pattern: /(->)[\w]+/,
            lookbehind: !0
        }
    }), e.languages.insertBefore('php', 'string', {
        'nowdoc-string': {
            pattern: /<<<'([^']+)'(?:\r\n?|\n)(?:.*(?:\r\n?|\n))*?\1;/,
            greedy: !0,
            alias: 'string',
            inside: {
                delimiter: {
                    pattern: /^<<<'[^']+'|[a-z_]\w*;$/i,
                    alias: 'symbol',
                    inside: {
                        punctuation: /^<<<'?|[';]$/
                    }
                }
            }
        },
        'heredoc-string': {
            pattern: /<<<(?:"([^"]+)"(?:\r\n?|\n)(?:.*(?:\r\n?|\n))*?\1;|([a-z_]\w*)(?:\r\n?|\n)(?:.*(?:\r\n?|\n))*?\2;)/i,
            greedy: !0,
            alias: 'string',
            inside: {
                delimiter: {
                    pattern: /^<<<(?:"[^"]+"|[a-z_]\w*)|[a-z_]\w*;$/i,
                    alias: 'symbol',
                    inside: {
                        punctuation: /^<<<"?|[";]$/
                    }
                },
                interpolation: null
            }
        },
        'single-quoted-string': {
            pattern: /'(?:\\[\s\S]|[^\\'])*'/,
            greedy: !0,
            alias: 'string'
        },
        'double-quoted-string': {
            pattern: /"(?:\\[\s\S]|[^\\"])*"/,
            greedy: !0,
            alias: 'string',
            inside: {
                interpolation: null
            }
        }
    }), delete e.languages.php.string;
    var n = {
        pattern: /{\$(?:{(?:{[^{}]+}|[^{}]+)}|[^{}])+}|(^|[^\\{])\$+(?:\w+(?:\[.+?]|->\w+)*)/,
        lookbehind: !0,
        inside: {
            rest: e.languages.php
        }
    };
    e.languages.php['heredoc-string'].inside.interpolation = n, e.languages.php['double-quoted-string'].inside.interpolation = n, e.hooks.add('before-tokenize', function (n) {
        if (/(?:<\?php|<\?)/gi.test(n.code)) {
            var i = /(?:<\?php|<\?)[\s\S]*?(?:\?>|$)/gi;
            e.languages['markup-templating'].buildPlaceholders(n, 'php', i);
        }
    }), e.hooks.add('after-tokenize', function (n) {
        e.languages['markup-templating'].tokenizePlaceholders(n, 'php');
    });
}(Prism);
Prism.languages.sql = {
    comment: {
        pattern: /(^|[^\\])(?:\/\*[\s\S]*?\*\/|(?:--|\/\/|#).*)/,
        lookbehind: !0
    },
    string: {
        pattern: /(^|[^@\\])("|')(?:\\[\s\S]|(?!\2)[^\\])*\2/,
        greedy: !0,
        lookbehind: !0
    },
    variable: /@[\w.$]+|@(["'`])(?:\\[\s\S]|(?!\1)[^\\])+\1/,
    'function': /\b(?:AVG|COUNT|FIRST|FORMAT|LAST|LCASE|LEN|MAX|MID|MIN|MOD|NOW|ROUND|SUM|UCASE)(?=\s*\()/i,
    keyword: /\b(?:ACTION|ADD|AFTER|ALGORITHM|ALL|ALTER|ANALYZE|ANY|APPLY|AS|ASC|AUTHORIZATION|AUTO_INCREMENT|BACKUP|BDB|BEGIN|BERKELEYDB|BIGINT|BINARY|BIT|BLOB|BOOL|BOOLEAN|BREAK|BROWSE|BTREE|BULK|BY|CALL|CASCADED?|CASE|CHAIN|CHAR(?:ACTER|SET)?|CHECK(?:POINT)?|CLOSE|CLUSTERED|COALESCE|COLLATE|COLUMNS?|COMMENT|COMMIT(?:TED)?|COMPUTE|CONNECT|CONSISTENT|CONSTRAINT|CONTAINS(?:TABLE)?|CONTINUE|CONVERT|CREATE|CROSS|CURRENT(?:_DATE|_TIME|_TIMESTAMP|_USER)?|CURSOR|CYCLE|DATA(?:BASES?)?|DATE(?:TIME)?|DAY|DBCC|DEALLOCATE|DEC|DECIMAL|DECLARE|DEFAULT|DEFINER|DELAYED|DELETE|DELIMITERS?|DENY|DESC|DESCRIBE|DETERMINISTIC|DISABLE|DISCARD|DISK|DISTINCT|DISTINCTROW|DISTRIBUTED|DO|DOUBLE|DROP|DUMMY|DUMP(?:FILE)?|DUPLICATE|ELSE(?:IF)?|ENABLE|ENCLOSED|END|ENGINE|ENUM|ERRLVL|ERRORS|ESCAPED?|EXCEPT|EXEC(?:UTE)?|EXISTS|EXIT|EXPLAIN|EXTENDED|FETCH|FIELDS|FILE|FILLFACTOR|FIRST|FIXED|FLOAT|FOLLOWING|FOR(?: EACH ROW)?|FORCE|FOREIGN|FREETEXT(?:TABLE)?|FROM|FULL|FUNCTION|GEOMETRY(?:COLLECTION)?|GLOBAL|GOTO|GRANT|GROUP|HANDLER|HASH|HAVING|HOLDLOCK|HOUR|IDENTITY(?:_INSERT|COL)?|IF|IGNORE|IMPORT|INDEX|INFILE|INNER|INNODB|INOUT|INSERT|INT|INTEGER|INTERSECT|INTERVAL|INTO|INVOKER|ISOLATION|ITERATE|JOIN|KEYS?|KILL|LANGUAGE|LAST|LEAVE|LEFT|LEVEL|LIMIT|LINENO|LINES|LINESTRING|LOAD|LOCAL|LOCK|LONG(?:BLOB|TEXT)|LOOP|MATCH(?:ED)?|MEDIUM(?:BLOB|INT|TEXT)|MERGE|MIDDLEINT|MINUTE|MODE|MODIFIES|MODIFY|MONTH|MULTI(?:LINESTRING|POINT|POLYGON)|NATIONAL|NATURAL|NCHAR|NEXT|NO|NONCLUSTERED|NULLIF|NUMERIC|OFF?|OFFSETS?|ON|OPEN(?:DATASOURCE|QUERY|ROWSET)?|OPTIMIZE|OPTION(?:ALLY)?|ORDER|OUT(?:ER|FILE)?|OVER|PARTIAL|PARTITION|PERCENT|PIVOT|PLAN|POINT|POLYGON|PRECEDING|PRECISION|PREPARE|PREV|PRIMARY|PRINT|PRIVILEGES|PROC(?:EDURE)?|PUBLIC|PURGE|QUICK|RAISERROR|READS?|REAL|RECONFIGURE|REFERENCES|RELEASE|RENAME|REPEAT(?:ABLE)?|REPLACE|REPLICATION|REQUIRE|RESIGNAL|RESTORE|RESTRICT|RETURNS?|REVOKE|RIGHT|ROLLBACK|ROUTINE|ROW(?:COUNT|GUIDCOL|S)?|RTREE|RULE|SAVE(?:POINT)?|SCHEMA|SECOND|SELECT|SERIAL(?:IZABLE)?|SESSION(?:_USER)?|SET(?:USER)?|SHARE|SHOW|SHUTDOWN|SIMPLE|SMALLINT|SNAPSHOT|SOME|SONAME|SQL|START(?:ING)?|STATISTICS|STATUS|STRIPED|SYSTEM_USER|TABLES?|TABLESPACE|TEMP(?:ORARY|TABLE)?|TERMINATED|TEXT(?:SIZE)?|THEN|TIME(?:STAMP)?|TINY(?:BLOB|INT|TEXT)|TOP?|TRAN(?:SACTIONS?)?|TRIGGER|TRUNCATE|TSEQUAL|TYPES?|UNBOUNDED|UNCOMMITTED|UNDEFINED|UNION|UNIQUE|UNLOCK|UNPIVOT|UNSIGNED|UPDATE(?:TEXT)?|USAGE|USE|USER|USING|VALUES?|VAR(?:BINARY|CHAR|CHARACTER|YING)|VIEW|WAITFOR|WARNINGS|WHEN|WHERE|WHILE|WITH(?: ROLLUP|IN)?|WORK|WRITE(?:TEXT)?|YEAR)\b/i,
    'boolean': /\b(?:TRUE|FALSE|NULL)\b/i,
    number: /\b0x[\da-f]+\b|\b\d+\.?\d*|\B\.\d+\b/i,
    operator: /[-+*\/=%^~]|&&?|\|\|?|!=?|<(?:=>?|<|>)?|>[>=]?|\b(?:AND|BETWEEN|IN|LIKE|NOT|OR|IS|DIV|REGEXP|RLIKE|SOUNDS LIKE|XOR)\b/i,
    punctuation: /[;[\]()`,.]/
};
Prism.languages.powershell = {
    comment: [{
        pattern: /(^|[^`])<#[\s\S]*?#>/,
        lookbehind: !0
    }, {
        pattern: /(^|[^`])#.*/,
        lookbehind: !0
    }],
    string: [{
        pattern: /"(?:`[\s\S]|[^`"])*"/,
        greedy: !0,
        inside: {
            'function': {
                pattern: /(^|[^`])\$\((?:\$\(.*?\)|(?!\$\()[^\r\n)])*\)/,
                lookbehind: !0,
                inside: {}
            }
        }
    }, {
        pattern: /'(?:[^']|'')*'/,
        greedy: !0
    }],
    namespace: /\[[a-z](?:\[(?:\[[^\]]*]|[^\[\]])*]|[^\[\]])*]/i,
    'boolean': /\$(?:true|false)\b/i,
    variable: /\$\w+\b/i,
    'function': [/\b(?:Add-(?:Computer|Content|History|Member|PSSnapin|Type)|Checkpoint-Computer|Clear-(?:Content|EventLog|History|Item|ItemProperty|Variable)|Compare-Object|Complete-Transaction|Connect-PSSession|ConvertFrom-(?:Csv|Json|StringData)|Convert-Path|ConvertTo-(?:Csv|Html|Json|Xml)|Copy-(?:Item|ItemProperty)|Debug-Process|Disable-(?:ComputerRestore|PSBreakpoint|PSRemoting|PSSessionConfiguration)|Disconnect-PSSession|Enable-(?:ComputerRestore|PSBreakpoint|PSRemoting|PSSessionConfiguration)|Enter-PSSession|Exit-PSSession|Export-(?:Alias|Clixml|Console|Csv|FormatData|ModuleMember|PSSession)|ForEach-Object|Format-(?:Custom|List|Table|Wide)|Get-(?:Alias|ChildItem|Command|ComputerRestorePoint|Content|ControlPanelItem|Culture|Date|Event|EventLog|EventSubscriber|FormatData|Help|History|Host|HotFix|Item|ItemProperty|Job|Location|Member|Module|Process|PSBreakpoint|PSCallStack|PSDrive|PSProvider|PSSession|PSSessionConfiguration|PSSnapin|Random|Service|TraceSource|Transaction|TypeData|UICulture|Unique|Variable|WmiObject)|Group-Object|Import-(?:Alias|Clixml|Csv|LocalizedData|Module|PSSession)|Invoke-(?:Command|Expression|History|Item|RestMethod|WebRequest|WmiMethod)|Join-Path|Limit-EventLog|Measure-(?:Command|Object)|Move-(?:Item|ItemProperty)|New-(?:Alias|Event|EventLog|Item|ItemProperty|Module|ModuleManifest|Object|PSDrive|PSSession|PSSessionConfigurationFile|PSSessionOption|PSTransportOption|Service|TimeSpan|Variable|WebServiceProxy)|Out-(?:Default|File|GridView|Host|Null|Printer|String)|Pop-Location|Push-Location|Read-Host|Receive-(?:Job|PSSession)|Register-(?:EngineEvent|ObjectEvent|PSSessionConfiguration|WmiEvent)|Remove-(?:Computer|Event|EventLog|Item|ItemProperty|Job|Module|PSBreakpoint|PSDrive|PSSession|PSSnapin|TypeData|Variable|WmiObject)|Rename-(?:Computer|Item|ItemProperty)|Reset-ComputerMachinePassword|Resolve-Path|Restart-(?:Computer|Service)|Restore-Computer|Resume-(?:Job|Service)|Save-Help|Select-(?:Object|String|Xml)|Send-MailMessage|Set-(?:Alias|Content|Date|Item|ItemProperty|Location|PSBreakpoint|PSDebug|PSSessionConfiguration|Service|StrictMode|TraceSource|Variable|WmiInstance)|Show-(?:Command|ControlPanelItem|EventLog)|Sort-Object|Split-Path|Start-(?:Job|Process|Service|Sleep|Transaction)|Stop-(?:Computer|Job|Process|Service)|Suspend-(?:Job|Service)|Tee-Object|Test-(?:ComputerSecureChannel|Connection|ModuleManifest|Path|PSSessionConfigurationFile)|Trace-Command|Unblock-File|Undo-Transaction|Unregister-(?:Event|PSSessionConfiguration)|Update-(?:FormatData|Help|List|TypeData)|Use-Transaction|Wait-(?:Event|Job|Process)|Where-Object|Write-(?:Debug|Error|EventLog|Host|Output|Progress|Verbose|Warning))\b/i, /\b(?:ac|cat|chdir|clc|cli|clp|clv|compare|copy|cp|cpi|cpp|cvpa|dbp|del|diff|dir|ebp|echo|epal|epcsv|epsn|erase|fc|fl|ft|fw|gal|gbp|gc|gci|gcs|gdr|gi|gl|gm|gp|gps|group|gsv|gu|gv|gwmi|iex|ii|ipal|ipcsv|ipsn|irm|iwmi|iwr|kill|lp|ls|measure|mi|mount|move|mp|mv|nal|ndr|ni|nv|ogv|popd|ps|pushd|pwd|rbp|rd|rdr|ren|ri|rm|rmdir|rni|rnp|rp|rv|rvpa|rwmi|sal|saps|sasv|sbp|sc|select|set|shcm|si|sl|sleep|sls|sort|sp|spps|spsv|start|sv|swmi|tee|trcm|type|write)\b/i],
    keyword: /\b(?:Begin|Break|Catch|Class|Continue|Data|Define|Do|DynamicParam|Else|ElseIf|End|Exit|Filter|Finally|For|ForEach|From|Function|If|InlineScript|Parallel|Param|Process|Return|Sequence|Switch|Throw|Trap|Try|Until|Using|Var|While|Workflow)\b/i,
    operator: {
        pattern: /(\W?)(?:!|-(eq|ne|gt|ge|lt|le|sh[lr]|not|b?(?:and|x?or)|(?:Not)?(?:Like|Match|Contains|In)|Replace|Join|is(?:Not)?|as)\b|-[-=]?|\+[+=]?|[*\/%]=?)/i,
        lookbehind: !0
    },
    punctuation: /[|{}[\];(),.]/
}, Prism.languages.powershell.string[0].inside.boolean = Prism.languages.powershell.boolean, Prism.languages.powershell.string[0].inside.variable = Prism.languages.powershell.variable, Prism.languages.powershell.string[0].inside.function.inside = Prism.languages.powershell;
Prism.languages.python = {
    comment: {
        pattern: /(^|[^\\])#.*/,
        lookbehind: !0
    },
    'triple-quoted-string': {
        pattern: /("""|''')[\s\S]+?\1/,
        greedy: !0,
        alias: 'string'
    },
    string: {
        pattern: /("|')(?:\\.|(?!\1)[^\\\r\n])*\1/,
        greedy: !0
    },
    'function': {
        pattern: /((?:^|\s)def[ \t]+)[a-zA-Z_]\w*(?=\s*\()/g,
        lookbehind: !0
    },
    'class-name': {
        pattern: /(\bclass\s+)\w+/i,
        lookbehind: !0
    },
    keyword: /\b(?:as|assert|async|await|break|class|continue|def|del|elif|else|except|exec|finally|for|from|global|if|import|in|is|lambda|nonlocal|pass|print|raise|return|try|while|with|yield)\b/,
    builtin: /\b(?:__import__|abs|all|any|apply|ascii|basestring|bin|bool|buffer|bytearray|bytes|callable|chr|classmethod|cmp|coerce|compile|complex|delattr|dict|dir|divmod|enumerate|eval|execfile|file|filter|float|format|frozenset|getattr|globals|hasattr|hash|help|hex|id|input|int|intern|isinstance|issubclass|iter|len|list|locals|long|map|max|memoryview|min|next|object|oct|open|ord|pow|property|range|raw_input|reduce|reload|repr|reversed|round|set|setattr|slice|sorted|staticmethod|str|sum|super|tuple|type|unichr|unicode|vars|xrange|zip)\b/,
    'boolean': /\b(?:True|False|None)\b/,
    number: /(?:\b(?=\d)|\B(?=\.))(?:0[bo])?(?:(?:\d|0x[\da-f])[\da-f]*\.?\d*|\.\d+)(?:e[+-]?\d+)?j?\b/i,
    operator: /[-+%=]=?|!=|\*\*?=?|\/\/?=?|<[<=>]?|>[=>]?|[&|^~]|\b(?:or|and|not)\b/,
    punctuation: /[{}[\];(),.:]/
};
Prism.languages.r = {
    comment: /#.*/,
    string: {
        pattern: /(['"])(?:\\.|(?!\1)[^\\\r\n])*\1/,
        greedy: !0
    },
    'percent-operator': {
        pattern: /%[^%\s]*%/,
        alias: 'operator'
    },
    'boolean': /\b(?:TRUE|FALSE)\b/,
    ellipsis: /\.\.(?:\.|\d+)/,
    number: [/\b(?:NaN|Inf)\b/, /(?:\b0x[\dA-Fa-f]+(?:\.\d*)?|\b\d+\.?\d*|\B\.\d+)(?:[EePp][+-]?\d+)?[iL]?/],
    keyword: /\b(?:if|else|repeat|while|function|for|in|next|break|NULL|NA|NA_integer_|NA_real_|NA_complex_|NA_character_)\b/,
    operator: /->?>?|<(?:=|<?-)?|[>=!]=?|::?|&&?|\|\|?|[+*\/^$@~]/,
    punctuation: /[(){}\[\],;]/
};
Prism.languages.typescript = Prism.languages.extend('javascript', {
    keyword: /\b(?:as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield|module|declare|constructor|namespace|abstract|require|type)\b/,
    builtin: /\b(?:string|Function|any|number|boolean|Array|symbol|console)\b/
}), Prism.languages.ts = Prism.languages.typescript;
Prism.languages.scss = Prism.languages.extend('css', {
    comment: {
        pattern: /(^|[^\\])(?:\/\*[\s\S]*?\*\/|\/\/.*)/,
        lookbehind: !0
    },
    atrule: {
        pattern: /@[\w-]+(?:\([^()]+\)|[^(])*?(?=\s+[{;])/,
        inside: {
            rule: /@[\w-]+/
        }
    },
    url: /(?:[-a-z]+-)*url(?=\()/i,
    selector: {
        pattern: /(?=\S)[^@;{}()]?(?:[^@;{}()]|&|#\{\$[-\w]+\})+(?=\s*\{(?:\}|\s|[^}]+[:{][^}]+))/m,
        inside: {
            parent: {
                pattern: /&/,
                alias: 'important'
            },
            placeholder: /%[-\w]+/,
            variable: /\$[-\w]+|#\{\$[-\w]+\}/
        }
    }
}), Prism.languages.insertBefore('scss', 'atrule', {
    keyword: [/@(?:if|else(?: if)?|for|each|while|import|extend|debug|warn|mixin|include|function|return|content)/i, {
        pattern: /( +)(?:from|through)(?= )/,
        lookbehind: !0
    }]
}), Prism.languages.scss.property = {
    pattern: /(?:[\w-]|\$[-\w]+|#\{\$[-\w]+\})+(?=\s*:)/i,
    inside: {
        variable: /\$[-\w]+|#\{\$[-\w]+\}/
    }
}, Prism.languages.insertBefore('scss', 'important', {
    variable: /\$[-\w]+|#\{\$[-\w]+\}/
}), Prism.languages.insertBefore('scss', 'function', {
    placeholder: {
        pattern: /%[-\w]+/,
        alias: 'selector'
    },
    statement: {
        pattern: /\B!(?:default|optional)\b/i,
        alias: 'keyword'
    },
    'boolean': /\b(?:true|false)\b/,
    'null': /\bnull\b/,
    operator: {
        pattern: /(\s)(?:[-+*\/%]|[=!]=|<=?|>=?|and|or|not)(?=\s)/,
        lookbehind: !0
    }
}), Prism.languages.scss.atrule.inside.rest = Prism.languages.scss;
Prism.languages.plsql = Prism.languages.extend('sql', {
    comment: [/\/\*[\s\S]*?\*\//, /--.*/]
}), 'Array' !== Prism.util.type(Prism.languages.plsql.keyword) && (Prism.languages.plsql.keyword = [Prism.languages.plsql.keyword]), Prism.languages.plsql.keyword.unshift(/\b(?:ACCESS|AGENT|AGGREGATE|ARRAY|ARROW|AT|ATTRIBUTE|AUDIT|AUTHID|BFILE_BASE|BLOB_BASE|BLOCK|BODY|BOTH|BOUND|BYTE|CALLING|CHAR_BASE|CHARSET(?:FORM|ID)|CLOB_BASE|COLAUTH|COLLECT|CLUSTERS?|COMPILED|COMPRESS|CONSTANT|CONSTRUCTOR|CONTEXT|CRASH|CUSTOMDATUM|DANGLING|DATE_BASE|DEFINE|DETERMINISTIC|DURATION|ELEMENT|EMPTY|EXCEPTIONS?|EXCLUSIVE|EXTERNAL|FINAL|FORALL|FORM|FOUND|GENERAL|HEAP|HIDDEN|IDENTIFIED|IMMEDIATE|INCLUDING|INCREMENT|INDICATOR|INDEXES|INDICES|INFINITE|INITIAL|ISOPEN|INSTANTIABLE|INTERFACE|INVALIDATE|JAVA|LARGE|LEADING|LENGTH|LIBRARY|LIKE[24C]|LIMITED|LONG|LOOP|MAP|MAXEXTENTS|MAXLEN|MEMBER|MINUS|MLSLABEL|MULTISET|NAME|NAN|NATIVE|NEW|NOAUDIT|NOCOMPRESS|NOCOPY|NOTFOUND|NOWAIT|NUMBER(?:_BASE)?|OBJECT|OCI(?:COLL|DATE|DATETIME|DURATION|INTERVAL|LOBLOCATOR|NUMBER|RAW|REF|REFCURSOR|ROWID|STRING|TYPE)|OFFLINE|ONLINE|ONLY|OPAQUE|OPERATOR|ORACLE|ORADATA|ORGANIZATION|ORL(?:ANY|VARY)|OTHERS|OVERLAPS|OVERRIDING|PACKAGE|PARALLEL_ENABLE|PARAMETERS?|PASCAL|PCTFREE|PIPE(?:LINED)?|PRAGMA|PRIOR|PRIVATE|RAISE|RANGE|RAW|RECORD|REF|REFERENCE|REM|REMAINDER|RESULT|RESOURCE|RETURNING|REVERSE|ROW(?:ID|NUM|TYPE)|SAMPLE|SB[124]|SEGMENT|SELF|SEPARATE|SEQUENCE|SHORT|SIZE(?:_T)?|SPARSE|SQL(?:CODE|DATA|NAME|STATE)|STANDARD|STATIC|STDDEV|STORED|STRING|STRUCT|STYLE|SUBMULTISET|SUBPARTITION|SUBSTITUTABLE|SUBTYPE|SUCCESSFUL|SYNONYM|SYSDATE|TABAUTH|TDO|THE|TIMEZONE_(?:ABBR|HOUR|MINUTE|REGION)|TRAILING|TRANSAC(?:TIONAL)?|TRUSTED|UB[124]|UID|UNDER|UNTRUSTED|VALIDATE|VALIST|VARCHAR2|VARIABLE|VARIANCE|VARRAY|VIEWS|VOID|WHENEVER|WRAPPED|ZONE)\b/i), 'Array' !== Prism.util.type(Prism.languages.plsql.operator) && (Prism.languages.plsql.operator = [Prism.languages.plsql.operator]), Prism.languages.plsql.operator.unshift(/:=/);
! function () {
    if ('undefined' != typeof self && self.Prism && self.document && document.createElement) {
        var e = {
                javascript: 'clike',
                actionscript: 'javascript',
                arduino: 'cpp',
                aspnet: ['markup', 'csharp'],
                bison: 'c',
                c: 'clike',
                csharp: 'clike',
                cpp: 'c',
                coffeescript: 'javascript',
                crystal: 'ruby',
                'css-extras': 'css',
                d: 'clike',
                dart: 'clike',
                django: 'markup',
                erb: ['ruby', 'markup-templating'],
                fsharp: 'clike',
                flow: 'javascript',
                glsl: 'clike',
                go: 'clike',
                groovy: 'clike',
                haml: 'ruby',
                handlebars: 'markup-templating',
                haxe: 'clike',
                java: 'clike',
                jolie: 'clike',
                kotlin: 'clike',
                less: 'css',
                markdown: 'markup',
                'markup-templating': 'markup',
                n4js: 'javascript',
                nginx: 'clike',
                objectivec: 'c',
                opencl: 'cpp',
                parser: 'markup',
                php: ['clike', 'markup-templating'],
                'php-extras': 'php',
                plsql: 'sql',
                processing: 'clike',
                protobuf: 'clike',
                pug: 'javascript',
                qore: 'clike',
                jsx: ['markup', 'javascript'],
                tsx: ['jsx', 'typescript'],
                reason: 'clike',
                ruby: 'clike',
                sass: 'css',
                scss: 'css',
                scala: 'java',
                smarty: 'markup-templating',
                soy: 'markup-templating',
                swift: 'clike',
                textile: 'markup',
                tt2: ['clike', 'markup-templating'],
                twig: 'markup',
                typescript: 'javascript',
                vbnet: 'basic',
                velocity: 'markup',
                wiki: 'markup',
                xeora: 'markup',
                xquery: 'markup'
            },
            a = {},
            c = 'none',
            t = document.getElementsByTagName('script');
        t = t[t.length - 1];
        var r = 'components/';
        if (t.hasAttribute('data-autoloader-path')) {
            var s = t.getAttribute('data-autoloader-path').trim();
            s.length > 0 && !/^[a-z]+:\/\//i.test(t.src) && (r = s.replace(/\/?$/, '/'));
        } else /[\w-]+\.js$/.test(t.src) && (r = t.src.replace(/[\w-]+\.js$/, 'components/'));
        var i = Prism.plugins.autoloader = {
                languages_path: r,
                use_minified: !0
            },
            t = function (e, a, c) {
                var t = document.createElement('script');
                t.src = e, t.async = !0, t.onload = function () {
                    document.body.removeChild(t), a && a();
                }, t.onerror = function () {
                    document.body.removeChild(t), c && c();
                }, document.body.appendChild(t);
            },
            n = function (e) {
                return i.languages_path + 'prism-' + e + (i.use_minified ? '.min' : '') + '.js';
            },
            l = function (e, c) {
                var t = a[e];
                t || (t = a[e] = {});
                var r = c.getAttribute('data-dependencies');
                !r && c.parentNode && 'pre' === c.parentNode.tagName.toLowerCase() && (r = c.parentNode.getAttribute('data-dependencies')), r = r ? r.split(/\s*,\s*/g) : [], o(r, function () {
                    p(e, function () {
                        Prism.highlightElement(c);
                    });
                });
            },
            o = function (e, a, c) {
                'string' == typeof e && (e = [e]);
                var t = 0,
                    r = e.length,
                    s = function () {
                        r > t ? p(e[t], function () {
                            t++, s();
                        }, function () {
                            c && c(e[t]);
                        }) : t === r && a && a(e);
                    };
                s();
            },
            p = function (c, r, s) {
                var i = function () {
                        var e = !1;
                        c.indexOf('!') >= 0 && (e = !0, c = c.replace('!', ''));
                        var i = a[c];
                        if (i || (i = a[c] = {}), r && (i.success_callbacks || (i.success_callbacks = []), i.success_callbacks.push(r)), s && (i.error_callbacks || (i.error_callbacks = []), i.error_callbacks.push(s)), !e && Prism.languages[c]) u(c);
                        else if (!e && i.error) m(c);
                        else if (e || !i.loading) {
                            i.loading = !0;
                            var l = n(c);
                            t(l, function () {
                                i.loading = !1, u(c);
                            }, function () {
                                i.loading = !1, i.error = !0, m(c);
                            });
                        }
                    },
                    l = e[c];
                l && l.length ? o(l, i) : i();
            },
            u = function (e) {
                a[e] && a[e].success_callbacks && a[e].success_callbacks.length && a[e].success_callbacks.forEach(function (a) {
                    a(e);
                });
            },
            m = function (e) {
                a[e] && a[e].error_callbacks && a[e].error_callbacks.length && a[e].error_callbacks.forEach(function (a) {
                    a(e);
                });
            };
        Prism.hooks.add('complete', function (e) {
            e.element && e.language && !e.grammar && e.language !== c && l(e.language, e.element);
        });
    }
}();
! function () {
    function e(e) {
        this.defaults = r({}, e);
    }

    function n(e) {
        return e.replace(/-(\w)/g, function (e, n) {
            return n.toUpperCase();
        });
    }

    function t(e) {
        for (var n = 0, t = 0; t < e.length; ++t) e.charCodeAt(t) == '	'.charCodeAt(0) && (n += 3);
        return e.length + n;
    }
    var r = Object.assign || function (e, n) {
        for (var t in n) n.hasOwnProperty(t) && (e[t] = n[t]);
        return e;
    };
    e.prototype = {
        setDefaults: function (e) {
            this.defaults = r(this.defaults, e);
        },
        normalize: function (e, t) {
            t = r(this.defaults, t);
            for (var i in t) {
                var o = n(i);
                'normalize' !== i && 'setDefaults' !== o && t[i] && this[o] && (e = this[o].call(this, e, t[i]));
            }
            return e;
        },
        leftTrim: function (e) {
            return e.replace(/^\s+/, '');
        },
        rightTrim: function (e) {
            return e.replace(/\s+$/, '');
        },
        tabsToSpaces: function (e, n) {
            return n = 0 | n || 4, e.replace(/\t/g, new Array(++n).join(' '));
        },
        spacesToTabs: function (e, n) {
            return n = 0 | n || 4, e.replace(new RegExp(' {' + n + '}', 'g'), '	');
        },
        removeTrailing: function (e) {
            return e.replace(/\s*?$/gm, '');
        },
        removeInitialLineFeed: function (e) {
            return e.replace(/^(?:\r?\n|\r)/, '');
        },
        removeIndent: function (e) {
            var n = e.match(/^[^\S\n\r]*(?=\S)/gm);
            return n && n[0].length ? (n.sort(function (e, n) {
                return e.length - n.length;
            }), n[0].length ? e.replace(new RegExp('^' + n[0], 'gm'), '') : e) : e;
        },
        indent: function (e, n) {
            return e.replace(/^[^\S\n\r]*(?=\S)/gm, new Array(++n).join('	') + '$&');
        },
        breakLines: function (e, n) {
            n = n === !0 ? 80 : 0 | n || 80;
            for (var r = e.split('\n'), i = 0; i < r.length; ++i)
                if (!(t(r[i]) <= n)) {
                    for (var o = r[i].split(/(\s+)/g), a = 0, s = 0; s < o.length; ++s) {
                        var l = t(o[s]);
                        a += l, a > n && (o[s] = '\n' + o[s], a = l);
                    }
                    r[i] = o.join('');
                } return r.join('\n');
        }
    }, 'undefined' != typeof module && module.exports && (module.exports = e), 'undefined' != typeof Prism && (Prism.plugins.NormalizeWhitespace = new e({
        'remove-trailing': !0,
        'remove-indent': !0,
        'left-trim': !0,
        'right-trim': !0
    }), Prism.hooks.add('before-sanity-check', function (e) {
            var n = Prism.plugins.NormalizeWhitespace;
            if (!e.settings || e.settings['whitespace-normalization'] !== !1) {
                if ((!e.element || !e.element.parentNode) && e.code) return e.code = n.normalize(e.code, e.settings), void 0;
                var t = e.element.parentNode,
                    r = /\bno-whitespace-normalization\b/;
                if (e.code && t && 'pre' === t.nodeName.toLowerCase() && !r.test(t.className) && !r.test(e.element.className)) {
                    for (var i = t.childNodes, o = '', a = '', s = !1, l = 0; l < i.length; ++l) {
                        var c = i[l];
                        c == e.element ? s = !0 : '#text' === c.nodeName && (s ? a += c.nodeValue : o += c.nodeValue, t.removeChild(c), --l);
                    }
                    if (e.element.children.length && Prism.plugins.KeepMarkup) {
                        var u = o + e.element.innerHTML + a;
                        e.element.innerHTML = n.normalize(u, e.settings), e.code = e.element.textContent;
                    } else e.code = o + e.code + a, e.code = n.normalize(e.code, e.settings);
                }
            }
        }));
}();