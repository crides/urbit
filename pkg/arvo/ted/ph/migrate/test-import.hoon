/-  spider,
    chat-view,
    publish,
    contact-view,
    contact-store,
    chat-store,
    group-store,
    metadata-store,
    post,
    graph-store,
    *resource
/+  *ph-io, strandio
=,  strand=strand:spider
=>
|%
++  chat-message
  |=  [our=@p =path wen=@da mes=cord]
  =/  act=action:chat-store
    :*  %message  path  `@uvH`(sham [our path mes])
        0  our  wen  [%text mes]
    ==
  (poke-app our %chat-hook %chat-action act)
::
++  publish-note
  |=  [our=@p host=@p book=@tas note=@tas title=@t body=@t]
  =/  act=action:publish  [%new-note host book note title body]
  (poke-app our %publish %publish-action act)
::
++  publish-comment
  |=  [our=@p host=@p book=@tas note=@tas body=@t]
  =/  act=action:publish  [%new-comment host book note body]
  (poke-app our %publish %publish-action act)
::
++  graph-post
  |=  [our=@p wen=@da rid=resource body=cord id=@]
  =/  =index:post  [id]~
  =/  =post:post  [our index wen [%text body]~ ~ ~]
  =/  =node:graph-store  [post %empty ~]
  =/  act=update:graph-store  [%0 wen %add-nodes rid (my [index node] ~)]
  (poke-app our %graph-push-hook %graph-update act)
--
::
::
^-  thread:spider
|=  vase
=/  m  (strand ,vase)
;<  az=tid:spider  bind:m  start-azimuth
;<  bol=bowl:spider  bind:m  get-bowl:strandio
::
::  test group import
::
=/  join-1=contact-view-action:contact-view  [%join ~zod %group-1]
=/  join-2=contact-view-action:contact-view  [%join ~zod %group-2]
=/  add-members-1=action:group-store
  [%add-members [~zod %group-1] (sy ~def ~ten ~)]
=/  add-members-2=action:group-store
  [%add-members [~zod %group-2] (sy ~def ~ten ~)]
;<  ~  bind:m  (poke-app ~bus %contact-view %contact-view-action join-1)
;<  ~  bind:m  (poke-app ~web %contact-view %contact-view-action join-1)
;<  ~  bind:m  (poke-app ~bus %contact-view %contact-view-action join-2)
;<  ~  bind:m  (poke-app ~web %contact-view %contact-view-action join-2)
;<  ~  bind:m  (poke-app ~zod %group-store %group-action add-members-1)
;<  ~  bind:m  (poke-app ~zod %group-store %group-action add-members-2)
;<  ~  bind:m  (sleep ~s20)
::
::  test metadata import
::
=/  change-group-1=metadata-action:metadata-store
  :*  %add
      /ship/~zod/group-1
      [%contacts /ship/~zod/group-1]
      'New Group 1 Title'
      'new description'
      0x0
      now.bol
      ~zod
  ==
=/  change-web-book=metadata-action:metadata-store
  :*  %add
      /ship/~web/book-3
      [%publish /~web/book-3]
      'New Book 3 Title'
      'new description'
      0x0
      now.bol
      ~web
  ==
;<  ~  bind:m  (poke-app ~zod %metadata-hook %metadata-action change-group-1)
;<  ~  bind:m  (poke-app ~web %metadata-hook %metadata-action change-web-book)
::
::  test contacts import
::
=/  add-zod=contact-action:contact-store
  :*  %add  /ship/~zod/group-1  ~zod
      'ZOD'  ''  ''  ''  ''  0x0  ~
  ==
=/  add-bus=contact-action:contact-store
  :*  %add  /ship/~zod/group-2  ~bus
      'BUS'  ''  ''  ''  ''  0x0  ~
  ==
;<  ~  bind:m  (poke-app ~zod %contact-hook %contact-action add-zod)
;<  ~  bind:m  (poke-app ~bus %contact-hook %contact-action add-bus)

  test chat import

=/  join-1  [%join ~zod /~zod/chat-1 %.y]
;<  ~  bind:m  (poke-app ~bus %chat-view %chat-view-action join-1)
;<  ~  bind:m  (poke-app ~web %chat-view %chat-view-action join-1)
;<  ~  bind:m  (sleep ~s30)
;<  ~  bind:m  (chat-message ~zod /~zod/chat-1 now.bol 'post import 1')
;<  ~  bind:m  (chat-message ~zod /~bus/chat-2 now.bol 'post import 2')
;<  ~  bind:m  (chat-message ~zod /~web/dm--zod now.bol 'post import 3')
;<  ~  bind:m  (chat-message ~bus /~zod/chat-1 now.bol 'post import 4')
;<  ~  bind:m  (chat-message ~bus /~bus/chat-2 now.bol 'post import 5')
;<  ~  bind:m  (chat-message ~web /~zod/chat-1 now.bol 'post import 6')
;<  ~  bind:m  (chat-message ~web /~bus/chat-2 now.bol 'post import 7')
;<  ~  bind:m  (chat-message ~web /~web/dm--zod now.bol 'post import 8')
::
::  test publish import
::
;<  ~  bind:m  (poke-app ~bus %publish %publish-action [%subscribe ~zod %book-1])
;<  ~  bind:m  (poke-app ~web %publish %publish-action [%subscribe ~zod %book-1])
;<  ~  bind:m  (sleep ~s60)
::
;<  ~  bind:m  (publish-note ~zod ~zod %book-1 %post-import-1 '1' '1')
;<  ~  bind:m  (publish-note ~zod ~bus %book-2 %post-import-2 '2' '2')
;<  ~  bind:m  (publish-note ~bus ~zod %book-1 %post-import-4 '4' '4')
;<  ~  bind:m  (publish-note ~web ~web %book-3 %post-import-5 '5' '5')
;<  ~  bind:m  (sleep ~s60)
;<  ~  bind:m  (publish-comment ~zod ~web %book-3 %post-import-5 'c1')
;<  ~  bind:m  (publish-comment ~bus ~web %book-3 %post-import-5 'c2')
::
::  test graph import
::
;<  ~  bind:m
  (poke-app ~bus %graph-pull-hook %pull-hook-action [%add ~zod ~zod %graph-1])
;<  ~  bind:m
  (poke-app ~web %graph-pull-hook %pull-hook-action [%add ~zod ~zod %graph-1])
;<  ~  bind:m  (sleep ~s30)
;<  ~  bind:m  (graph-post ~zod now.bol [~bus %graph-2] 'post 7' 7)
;<  ~  bind:m  (graph-post ~web now.bol [~bus %graph-2] 'post 8' 8)
;<  ~  bind:m  (graph-post ~bus now.bol [~bus %graph-2] 'post 9' 9)
;<  ~  bind:m  (graph-post ~zod now.bol [~zod %graph-1] 'post 10' 10)
;<  ~  bind:m  (graph-post ~web now.bol [~zod %graph-1] 'post 11' 11)
;<  ~  bind:m  (graph-post ~bus now.bol [~zod %graph-1] 'post 12' 12)
::
;<  ~  bind:m  (wait-for-output ~web "XXXX")
(pure:m *vase)
