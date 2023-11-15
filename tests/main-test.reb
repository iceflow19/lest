; CONFIGURATION: simple test function
[
	function? tf: func [data][lest data]
]

;;-----------------------

; string

[ "lest" = tf [ "lest" ] ]
[ "<lest>" = tf [ plain "<lest>" ] ]
[ "&lt;lest&gt;" = tf [ html "<lest>" ] ]
[ {<a href="lest">lest</a>} = tf [ markdown "<lest>" ] ]

; comment

[ {} = tf [ comment [ b "bold" ] ] ]

; stop

[ {<div>hello</div>} = tf [ div "hello" stop div "world" ] ]

; paired tags

[ {<div>div</div>}				= tf [ div "div" ] ]
[ {<span>span</span>}			= tf [ span "span"] ]
[ {<b>bold</b>}					= tf [ b "bold" ] ]
[ {<i>italic</i>}				= tf [ i "italic" ] ]
[ {<p>para</p>}					= tf [ p "para" ] ]
[ {<p>para^/with newline</p>}	= tf [ p "para^/with newline" ] ]
[ {<p>para</p>}					= tf [ p [ "para" ] ] ]
[ {<p>paragraph</p>}			= tf [ p [ "para" "graph" ] ] ]
[ {<p><b>para</b>graph</p>}		= tf [ p [ b "para" "graph" ] ] ]
[ {<em>em</em>}					= tf [ em "em" ] ]
[ {<strong>strong</strong>}		= tf [ strong "strong" ] ]
[ {<small>Smallprint</small>}	= tf [ small "Smallprint" ] ]
[ {<footer>footer</footer>}		= tf [ footer "footer" ] ]

; unpaired tags

[ {<br>} = tf [ br ] ]
[ {<hr>} = tf [ hr ] ]

; styles (id & class)

[ {<b id="bold-style">bold</b>} 						= tf [ b #bold-style "bold" ] ]
[ {<b class="bold-style">bold</b>} 						= tf [ b .bold-style "bold" ] ]
[ {<b class="bold style">bold</b>} 						= tf [ b .bold .style "bold" ] ]
[ {<b id="bold-text" class="bold style">bold</b>} 		= tf [ b #bold-text .bold .style "bold" ] ]

[ {<div id="test">test</div>} 							= tf [ set x "test" div id x "test" ] ]
[ {<div class="test">test</div>}						= tf [ set x "test" div class x "test" ] ]
[ {<div id="test-id" class="test">test</div>} 			= tf [ set xid "test-id" set x "test" div id xid class x "test" ] ]
[ {<div id="test-id" class="test my-class">test</div>} 	= tf [ set xid "test-id" set x "test" div id xid class x .my-class "test" ] ]
[ {<div class="test-1">test</div>} 						= tf [ set x "test" div class [x #"-" 1] "test" ] ]
[ {<div id="test-1">test</div>} 						= tf [ set x "test" div id [x #"-" 1] "test" ] ]
[ {<div id="my-test" class="test-1">test</div>} 		= tf [ set x "test" div id ["my" #"-" 'test] class [x #"-" 1] "test" ] ]
[ {<b>test</b>} 										= tf [ set x (join "te" "st") b x ] ]
[ {<b>test</b>} 										= tf [ set x ("te") set y (join x "st") b y ] ]

; tag nesting

[ {<b><i>bold italic</i></b>} 							= tf [ b [ i "bold italic" ] ] ]
[ {<b id="bold"><i id="italic">bold italic</i></b>} 	= tf [ b #bold [ i #italic "bold italic" ] ] ]
[ {<b class="bold"><i id="italic">bold italic</i></b>} 	= tf [ b .bold [ i #italic "bold italic" ] ] ]
[ {<b id="bold"><i class="italic">bold italic</i></b>} 	= tf [ b #bold [ i .italic "bold italic" ] ] ]
[ {<b class="bold"><i class="italic">bold italic</i></b>} 				= tf [ b .bold [ i .italic "bold italic" ] ] ]
[ {<b class="bold style"><i class="italic">bold italic</i></b>} 		= tf [ b .bold .style [ i .italic "bold italic" ] ] ]
[ {<b class="bold style"><i class="italic style">bold italic</i></b>} 	= tf [ b .bold .style [ i .italic .style "bold italic" ] ] ]


; SCRIPT tag

[ {<script src="script.js"></script>} 								= tf [ script %script.js ] ]
[ {<script src="http://iluminat.cz/script.js"></script>} 			= tf [ script http://iluminat.cz/script.js ] ]
[ {<script src="script.js"></script>} 								= tf [ script %script.js ] ]
[ {<script type="text/javascript">alert("hello world");</script>} 	= tf [ script {alert("hello world");} ] ]

; LINK tag

[ {<a href="#">home</a>} = tf [ a %# "home" ] ]
[ {<a href="#">home</a>} = tf [ link %# "home" ] ]
[ {<a href="#about">about</a>} = tf [ link %#about "about" ] ]
[ {<a href="about">about file</a>} = tf [ link %about "about file" ] ]
[ {<a href="http://www.about.at">about web</a>} = tf [ link http://www.about.at "about web" ] ]
[ {<a class="blue" href="#">home</a>} = tf [ link %# .blue "home"] ]
[ {<a id="blue" href="#">home</a>} = tf [ link %# #blue "home"] ]
[ {<a id="blue" class="main" href="#">home</a>} = tf [ link %# #blue .main "home"] ]
[ equal? {<a id="blue" class="main" href="#"><div id="link" class="link-class">home</div></a>}
	tf [
		link %# #blue .main [
			div .link-class #link "home"
		]
	]
]
[ equal? {<div id="outer" class="border"><a id="blue" class="main" href="#"><div id="link" class="link-class">home</div></a></div>}
	tf [
		div #outer .border [
			link %# #blue .main [
				div .link-class #link "home"
			]
		]
	]
]
[ equal? {<a href="html://www.lest.cz">lest</a>} tf [set target html://www.lest.cz set text "lest" link target text] ]
[ equal? {<a href="html://www.lest.cz">2</a>} tf [set target html://www.lest.cz set text 1 + 1 link target text] ]

; IMG tag

[ {<img src="brno.jpg" alt="Image">} = tf [ img %brno.jpg ] ]
[ {<img src="brno.jpg" alt="Image">} = tf [ image %brno.jpg ] ]
[ {<img class="adamov" src="brno.jpg" alt="Image">} = tf [ image %brno.jpg .adamov] ]
[ {<img id="adamov" src="brno.jpg" alt="Image">} = tf [ image #adamov %brno.jpg] ]
[ {<img id="obr" class="adamov" src="brno.jpg" alt="Image">} = tf [ image #obr %brno.jpg .adamov] ]
[ {<img id="obr" class="adamov ivancice" src="brno.jpg" alt="Image">} = tf [ image #obr %brno.jpg .adamov .ivancice ] ]
[ equal?
		{<div id="okraj" class="border small"><img id="obr" class="adamov ivancice" src="brno.jpg" alt="Image"></div>}
		tf [ div .border #okraj .small [image #obr %brno.jpg .adamov .ivancice] ]
]

; LISTS

[ "<ul><li>jedna</li></ul>" = tf [ ul li "jedna" ] ]
[ "<ul><li>jedna</li><li>dva</li></ul>" = tf [ ul li "jedna" li "dva"] ]
[ equal?
	{<ul id="list"><li id="first" class="item">jedna</li><li id="second" class="item">dva</li></ul>}
	tf [ ul #list li .item #first "jedna" li #second .item "dva" ]
]
[ "<ul><li><span>inner element</span></li></ul>" = tf [ ul li [ span "inner element" ] ] ]
[ "<ol><li>jedna</li></ol>" = tf [ ol li "jedna" ] ]
[ "<ol><li>jedna</li><li>dva</li></ol>" = tf [ ol li "jedna" li "dva" ] ]
[ equal?
	{<ol id="list"><li id="first" class="item">jedna</li><li id="second" class="item">dva</li></ol>}
	tf [ ol #list li .item #first "jedna" li #second .item "dva" ]
]
[ equal?
	{<ul><li><ul><li>nested</li><li>this too</li></ul></li><li>back on surface</li></ul>}
	tf [ ul li [ ul li "nested" li "this too" ] li "back on surface" ]
]
[ "<dl><dt>def</dt><dd>val</dd></dl>" = tf [ dl "def" "val" ] ]
[ "<dl><dt>def 1</dt><dd>val 1</dd><dt>def 2</dt><dd>val 2</dd></dl>" = tf [ dl "def 1" "val 1" "def 2" "val 2" ] ]
[ {<dl><dt><strong>def</strong></dt><dd>val</dd></dl>} = tf [dl markdown "**def**" "val"] ]
[ {<dl class="dl-horizontal"><dt>def</dt><dd>val</dd></dl>} = tf [ dl horizontal "def" "val" ] ]
[ {<dl><dt class="def-class">def</dt><dd class="val-class">val</dd></dl>} = tf [ dl "def" .def-class "val" .val-class ] ]


; HEADINGS

[ {<h1>Brno</h1>} = tf [ h1 "Brno" ] ]
[ {<h2>Brno</h2>} = tf [ h2 "Brno" ] ]
[ {<h3>Brno</h3>} = tf [ h3 "Brno" ] ]
[ {<h4>Brno</h4>} = tf [ h4 "Brno" ] ]
[ {<h5>Brno</h5>} = tf [ h5 "Brno" ] ]
[ {<h6>Brno</h6>} = tf [ h6 "Brno" ] ]
[ {<h1 class="city">Brno</h1>} = tf [ h1 .city "Brno" ] ]
[ {<h2 class="city">Brno</h2>} = tf [ h2 .city "Brno" ] ]
[ {<h3 class="city">Brno</h3>} = tf [ h3 .city "Brno" ] ]
[ {<h4 class="city">Brno</h4>} = tf [ h4 .city "Brno" ] ]
[ {<h5 class="city">Brno</h5>} = tf [ h5 .city "Brno" ] ]
[ {<h6 class="city">Brno</h6>} = tf [ h6 .city "Brno" ] ]
[ {<h1 id="city">Brno</h1>} = tf [ h1 #city "Brno" ] ]
[ {<h2 id="city">Brno</h2>} = tf [ h2 #city "Brno" ] ]
[ {<h3 id="city">Brno</h3>} = tf [ h3 #city "Brno" ] ]
[ {<h4 id="city">Brno</h4>} = tf [ h4 #city "Brno" ] ]
[ {<h5 id="city">Brno</h5>} = tf [ h5 #city "Brno" ] ]
[ {<h6 id="city">Brno</h6>} = tf [ h6 #city "Brno" ] ]

; FORMS

[ equal?
	{<form action="script" method="post" role="form"><div class="form-group"><label for="name">Your name:</label><input class="form-control" type="text" name="name"></div></form>}
	tf [ form %script [ text name "Your name:" ] ]
]
[ equal?
	{<form action="script" method="post" role="form"><div class="form-group"><label for="pass">Password:</label><input class="form-control" type="password" name="pass"></div></form>}
	tf [ form %script [ password pass "Password:" ] ]
]
[ equal?
	{<form action="script" method="post" role="form"><div class="form-group"><label for="mail">Your email:</label><input class="form-control" type="email" name="mail"></div></form>}
	tf [ form %script [ email mail "Your email:" ] ]
]
[ equal?
	{<form action="script" method="post" role="form"><div class="form-group"><label for="name">Your name:</label><input class="form-control" type="text" name="name"></div><div class="form-group"><label for="pass">Password:</label><input class="form-control" type="password" name="pass"></div><div class="form-group"><label for="mail">Your email:</label><input class="form-control" type="email" name="mail"></div></form>}
	tf [
		form %script [
			text name "Your name:"
			password pass "Password:"
			email mail "Your email:"
		]
	]
]
[
	equal?
	{<form action="script" method="post" role="form"><div class="checkbox"><label><input type="checkbox" name="cb1">Check me</label></div></form>}
	tf [ form %script [ checkbox cb1 "Check me" ] ]
]
[
	equal?
	{<form action="script" method="post" role="form"><div class="checkbox"><label><input checked="true" type="checkbox" name="cb1">Check me</label></div></form>}
	tf [ form %script [ checkbox cb1 checked "Check me" ] ]
]
[
	equal?
	{<form action="script" method="post" role="form"><div class="checkbox"><label><input type="checkbox" name="cb1">Check me</label></div></form>}
	tf [ form %script [ checkbox cb1 if false checked "Check me" ] ]
]
[
	equal?
	{<form action="script" method="post" role="form"><div class="checkbox"><label><input checked="true" type="checkbox" name="cb1">Check me</label></div></form>}
	tf [ form %script [ checkbox cb1 if true checked "Check me" ] ]
]
[
	equal?
	{<form action="script" method="post" role="form"><button class="btn btn-default" type="submit">Bye</button></form>}
	tf [ form %script [ submit "Bye" ] ]
]
[
	equal?
	{<form action="script" method="post" role="form"><button class="btn btn-default" type="submit">Bye</button></form>}
	tf [ form %script [ submit "Bye" ] ]
]
[
	equal?
	{<form action="script" method="post" role="form"><button class="btn btn-default" type="submit" name="action" value="login">Log In</button></form>}
	tf [ form %script [ submit with action "login" "Log In" ] ]
]
[
	equal?
	{<form action="script" method="post" role="form"><select name="sl"><option value="a">a</option><option value="b">b</option></select></form>}
	tf [form %script [select sl a "a" b "b"]]
]
[
	equal?
	{<form action="script" method="post" role="form"><select name="sl"><option value="a" selected="selected">a</option><option value="b">b</option></select></form>}	
	tf [form %script [select sl a "a" selected b "b"]]
]
[
	equal?
	{<form action="a" method="post" role="form"><div class="radio"><input id="radio_foo_bar" type="radio" name="foo" value="bar"><label for="radio_foo_bar">bar</label></div><div class="radio"><input id="radio_foo_pub" type="radio" name="foo" value="pub"><label for="radio_foo_pub">pub</label></div></form>}
	tf [form %a [radio foo "bar" "bar" radio foo "pub" "pub"]]
]
[
	equal?
	{<form action="a" method="post" role="form"><div class="radio"><input id="foo1" type="radio" name="foo" value="bar"><label for="foo1">bar</label></div><div class="radio"><input id="foo2" type="radio" name="foo" value="pub"><label for="foo2">pub</label></div></form>}
	tf [form %a [radio foo "bar" #foo1 "bar" radio foo "pub" #foo2 "pub"]]
]
[
	equal?
	{<form action="a" method="post" role="form"><div class="radio"><input id="radio_foo_bar" type="radio" name="foo" value="bar"><label for="radio_foo_bar">bar</label></div><div class="radio"><input id="radio_foo_pub" checked="true" type="radio" name="foo" value="pub"><label for="radio_foo_pub">pub</label></div></form>}
	tf [form %a [radio foo "bar" "bar" radio foo "pub" "pub" checked]]
]
[
	equal?
	{<form action="a" method="post" role="form"><div class="radio"><input id="foo1" type="radio" name="foo" value="bar"><label for="foo1">bar</label></div><div class="radio"><input id="foo2" checked="true" type="radio" name="foo" value="pub"><label for="foo2">pub</label></div></form>}
	tf [form %a [radio foo "bar" #foo1 "bar" radio foo "pub" #foo2 "pub" checked]]
]
; USER tags

[ {<span>nazdar</span>} = tf [ nazdar: [ span "nazdar" ] nazdar ] ]
[ {<div><span>nazdar</span></div>} = tf [ nazdar: [ span "nazdar" ] div [ nazdar ] ] ]
[ {<div><span>nazdar</span></div>} = tf [ nazdar: [ div [ span "nazdar" ] ] nazdar ] ]
[ {<span>ahoj</span>, <span>nazdar</span>!} = tf [ ahoj: [ span "ahoj" ] nazdar: [ span "nazdar" ] ahoj ", " nazdar "!" ] ]

[ {<div class="red">Rebol</div>} = tf [ red-div: value string! [ div .red value ] red-div "Rebol" ] ]
[ {<div class="red"><span>Rebol</span></div>} = tf [ red-div: value block! [ div .red value ] red-div [ span "Rebol" ] ] ]
[ equal?
	{<div class="red"><span id="lang">Rebol</span></div>}
	tf [
		red-div: value block! [ div .red value ]
		lang-span: value string! [ span #lang value ]
		red-div [ lang-span "Rebol" ]
	]
]
[ equal?
	{<div class="red"><span id="lang">Rebol</span></div>}
	tf [
		red-div: value block! [ div .red value ]
		lang-span: value string! [ span #lang value ]
		red-lang: value string! [ red-div [ lang-span value ] ]
		red-lang "Rebol"
	]
]
[ {<span>Hello world</span>} = tf [ greeting: what string! who string! [ span [ what " " who ] ] greeting "Hello" "world" ] ]
[ {<span>Hello world</span>} = tf [ greeting: who string! what string! [ span [ what " " who ] ] greeting "world" "Hello" ] ]
[ equal?
	{<span class="greeting">Hello</span>, <span class="name">world</span>!}
	tf [
		exclamation: ["!"]
		greeting: salute string! name string! [
			span .greeting salute
			", "
			span .name name
			exclamation
		]
		greeting "Hello" "world"
	]
]
[ {<span>nazdar</span>} = tf [ pozdrav: [span "ahoj"] pozdrav: [span "nazdar"] pozdrav] ]
; dynamic code

[ {<div>Brno</div>} = tf [ either true div span "Brno" ] ]
[ {<span>Brno</span>} = tf [ either false div span "Brno" ] ]
[ {<div>Brno</div>} = tf [ set val true either val div span "Brno" ] ]
[ {<span>Brno</span>} = tf [ set val false either val div span "Brno" ] ]
[ {<div class="city">Brno</div>} = tf [ 
	set citizens 400'001
	div either citizens > 400'000 .city .village "Brno" 
] ]
[ {<div class="village">Adamov</div>} = tf [ 
	set citizens 4'500 
	div either citizens > 400'000 .city .village "Adamov" 
] ]
[ {<div id="greeting">Hello World</div>} = tf [ div #greeting either true "Hello World" "Hello Mars" ] ]
[ {<div id="greeting">Hello Mars</div>} = tf [ div #greeting either false "Hello World" "Hello Mars" ] ]
[ {<div>Brno</div>} = tf [ if true div "Brno" ] ]
[ {<div>Brno</div>} = tf [ if true [ div "Brno" ] ] ]
[ {} = tf [ if false [ div "Brno" ] ] ]
[ {Brno} = tf [ if false div "Brno" ] ]
[ {<span>value is </span>one} = tf [ set x 1 span "value is " switch x [ 0 "zero" 1 "one" 2 "two"] default "many" ] ]
[ {<span>value is </span>many} = tf [ set x 23 span "value is " switch x [ 0 "zero" 1 "one" 2 "two"] default "many" ] ]
[ {<span>value is </span><span>one</span>} = tf [ set x 1 span "value is " span switch x [ 0 "zero" 1 "one" 2 "two"] default "many" ] ]
[ {<span>value is </span><span>many</span>} = tf [ set x 23 span "value is " span switch x [ 0 "zero" 1 "one" 2 "two"] default "many" ] ]
[ {<span>Brno</span>} = tf [ set name "Brno" span name ] ]
[ {<span>Brno</span>} = tf [ set name ["Br" "no"] span name] ]
[ {<span>Brno</span>} = tf [ set name [span "Brno"] name] ]

; loops
; -- repeat
[ 	
	equal?
		"<div>1</div><div>2</div><div>3</div>"
		tf [repeat [div :x] replace :x from ["1" "2" "3"]] 
]
[
	equal?
		"<div>1</div><div>2</div><div>3</div>"
		tf [repeat [div :x] replace :x 3 times with (form index)] 
]
[
	equal?
		 {<div>1</div><span>2</span><div>2</div><span>4</span><div>3</div><span>6</span>}
		tf [repeat [div :x span :y] replace :x :y 3 times with (reduce [form index form 2 * index])]
]
; -- for
[
	equal? 
		tf [for i 3 times [span i]]
		"<span>1</span><span>2</span><span>3</span>"
]
[
	equal? 
		tf [x: 3 for i x times [span i]]
		"<span>1</span><span>2</span><span>3</span>"
]
[
	equal? 
		tf [for i in [1 2 3] [span i]]
		"<span>1</span><span>2</span><span>3</span>"
]
[
	equal? 
		tf [set x [1 2 3] for i in x [span i]]
		"<span>1</span><span>2</span><span>3</span>"
]
; -- <<
[equal? tf [span << ["a" "b"]]  "<span>a</span><span>b</span>" ]
[equal? tf [set data ["a" "b"] span << data]  "<span>a</span><span>b</span>" ]
[equal? tf [set inner ["a" "b"] div << ["x" [span << inner]]] {<div>x</div><div><span>a</span><span>b</span></div>} ]
[equal? tf [set x ["a" "b"] tag: value string! [span .tag value] tag << x]  {<span class="tag">a</span><span class="tag">b</span>} ]



; inline code

[ {<b>bold</b>} = tf [([b "bold"])] ]
[ {<b>bold</b>} = tf [(reduce ['b join "bo" "ld"])] ]

; ========= tests with header ===========

[
	equal?
		{<!DOCTYPE html> <html lang="en-US"> <head> <title>Page generated with Lest</title> <meta charset="utf-8"> <script src="js/lest.js"></script> </head> <body></body></html>}
		trim/lines tf [ head body "" ]
]
[
	equal?
		{<!DOCTYPE html> <html lang="en-US"> <head> <title>test</title> <meta charset="utf-8"> <script src="js/lest.js"></script> </head> <body></body></html>}
		trim/lines tf [ head title "test" body "" ]
]
[
	equal?
		{<!DOCTYPE html> <html lang="cs"> <head> <title>Page generated with Lest</title> <meta charset="utf-8"> <script src="js/lest.js"></script> </head> <body></body></html>}
		trim/lines tf [ head lang cs body "" ]
]
[
	equal?
		{<!DOCTYPE html> <html lang="cs"> <head> <title>Page generated with Lest</title> <meta charset="utf-8"> <script src="js/lest.js"></script> </head> <body></body></html>}
		trim/lines tf [ head language cs body "" ]
]
[
	equal?
		{<!DOCTYPE html> <html lang="en-US"> <head> <title>Page generated with Lest</title> <meta charset="utf-8"> <link href="asdf.css" rel="stylesheet"> <script src="js/lest.js"></script> </head> <body></body></html>}
		trim/lines tf [head stylesheet %asdf.css body ""]
]
[
	equal?
		{<!DOCTYPE html> <html lang="en-US"> <head> <title>Page generated with Lest</title> <meta charset="utf-8"> <link href="asdf.css" rel="stylesheet"> <link href="ghjk.css" rel="stylesheet"> <script src="js/lest.js"></script> </head> <body></body></html>}
		trim/lines tf [head stylesheet %asdf.css %ghjk.css body ""]
]
[
	equal?
		{<!DOCTYPE html> <html lang="en-US"> <head> <title>Page generated with Lest</title> <meta charset="utf-8"> <link href="http://css.org/asdf.css" rel="stylesheet"> <script src="js/lest.js"></script> </head> <body></body></html>}
		trim/lines tf [head stylesheet http://css.org/asdf.css body ""]
]

; math
[equal? {2} tf [1 + 1]]
[equal? {2} tf ["1" + 1]]
[equal? {2} tf [1 + "1"]]
[equal? {2} tf ["1" + "1"]]
[equal? {2} tf [set x 1 x + 1]]
[equal? {2} tf [set x 1 x + "1"]]
[equal? {2} tf [set x 1 1 + x]]
[equal? {2} tf [set x 1 "1" + x]]
[equal? {2} tf [set x 1 x + x]]
[equal? {2} tf [set x 1 ++ x x]]
[equal? {2} tf [set x "1" x + 1]]
[equal? {2} tf [set x "1" x + "1"]]
[equal? {2} tf [set x "1" 1 + x]]
[equal? {2} tf [set x "1" "1" + x]]
[equal? {2} tf [set x "1" x + x]]
[equal? {2} tf [set x "1" ++ x x]]
[equal? {0} tf [1 - 1]]
[equal? {0} tf ["1" - 1]]
[equal? {0} tf [1 - "1"]]
[equal? {0} tf ["1" - "1"]]
[equal? {0} tf [set x 1 x - 1]]
[equal? {0} tf [set x 1 x - "1"]]
[equal? {0} tf [set x 1 1 - x]]
[equal? {0} tf [set x 1 "1" - x]]
[equal? {0} tf [set x 1 x - x]]
[equal? {0} tf [set x 1 -- x x]]
[equal? {0} tf [set x "1" x - 1]]
[equal? {0} tf [set x "1" x - "1"]]
[equal? {0} tf [set x "1" 1 - x]]
[equal? {0} tf [set x "1" "1" - x]]
[equal? {0} tf [set x "1" x - x]]
[equal? {0} tf [set x "1" -- x x]]
[equal? {4} tf [2 * 2]]
[equal? {4} tf ["2" * 2]]
[equal? {4} tf [2 * "2"]]
[equal? {4} tf ["2" * "2"]]
[equal? {4} tf [set x 2 x * 2]]
[equal? {4} tf [set x 2 x * "2"]]
[equal? {4} tf [set x 2 2 * x]]
[equal? {4} tf [set x 2 "2" * x]]
[equal? {4} tf [set x 2 x * x]]
[equal? {4} tf [set x "2" x * 2]]
[equal? {4} tf [set x "2" x * "2"]]
[equal? {4} tf [set x "2" 2 * x]]
[equal? {4} tf [set x "2" "2" * x]]
[equal? {4} tf [set x "2" x * x]]

; comparison

[equal? {true} tf [if 1 = 1 "true"]]
[equal? {} tf [if 1 = 2 "true"]]
[equal? {true} tf [if 1 = "1" "true"]]
[equal? {} tf [if 1 = "2" "true"]]
