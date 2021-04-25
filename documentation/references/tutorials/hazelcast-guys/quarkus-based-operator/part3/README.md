<!DOCTYPE html>
<html lang="en-US">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0">
<meta name='robots' content='max-image-preview:large' />
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/6472997f-571e-423e-939f-a45bd43f7426.woff2" data-wpacu-preload-font="1" crossorigin>
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/fontawesome-webfont.woff2?v=4.7.0" data-wpacu-preload-font="1" crossorigin>
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/da55b34f-955e-4e88-a82d-a53ee43fbd46.woff2" data-wpacu-preload-font="1" crossorigin>
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/5034f5ca-70f1-4f29-bb9c-8e837a950ec8.woff2" data-wpacu-preload-font="1" crossorigin>
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/7d02c168-550d-4626-a0ad-c558f8de9a8e.woff2" data-wpacu-preload-font="1" crossorigin>
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/0d5ee4ab-684e-471b-afdf-8e8fb1b02564.woff2" data-wpacu-preload-font="1" crossorigin>
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/instanaiconfont.woff2?22555420" data-wpacu-preload-font="1" crossorigin>
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/999dd6a4-c652-4d7c-8eed-037398f59dc8.woff2" data-wpacu-preload-font="1" crossorigin>
<link rel="preload" as="font" href="/wp-content/themes/Instana%20Inc/assets/fonts/db6fe929-f6d1-49c0-b801-fb3819bdab52.woff2" data-wpacu-preload-font="1" crossorigin>

<title>Writing a Kubernetes Operator in Java: Part 3 - Instana</title>
<meta name="robots" content="index, follow, max-snippet:-1, max-image-preview:large, max-video-preview:-1" />
<link rel="canonical" href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-3/" />
<meta property="og:locale" content="en_US" />
<meta property="og:type" content="article" />
<meta property="og:title" content="Writing a Kubernetes Operator in Java: Part 3 - Instana" />
<meta property="og:description" content="In this Blog post, we will implement a stripped-down version of this functionality. We create a custom resource defining some special roles, and we will implement an operator creating a daemon set when that resource is created." />
<meta property="og:url" content="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-3/" />
<meta property="og:site_name" content="Instana" />
<meta property="article:published_time" content="2019-07-02T10:36:39+00:00" />
<meta property="article:modified_time" content="2020-04-07T08:20:28+00:00" />
<meta property="og:image" content="https://www.instana.com/media/Default_Post_Image.png" />
<meta property="og:image:width" content="1400" />
<meta property="og:image:height" content="800" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:label1" content="Written by">
<meta name="twitter:data1" content="Fabian Staeber">
<meta name="twitter:label2" content="Est. reading time">
<meta name="twitter:data2" content="12 minutes">

<link rel='dns-prefetch' href='//use.fontawesome.com' />
<link rel='dns-prefetch' href='//s.w.org' />
<link rel='stylesheet' id='wpacu-combined-css-head-1' href='https://www.instana.com/wp-content/cache/asset-cleanup/css/head-f5eb1eb19d1e5142323024b48e1cfb48ef6fb942.css' type='text/css' media='all' />
<link rel='stylesheet' id='single-style-css' href='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/css/single-style.css?ver=5.7.1' type='text/css' media='all' />
<link rel='stylesheet' id='bootstrap-css-4-css' href='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/css/bootstrap.min.css?ver=5.7.1' type='text/css' media='all' />
<link rel='stylesheet' id='font-awesome-free-css' href='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/css/font-awesome.min.css?ver=5.7.1' type='text/css' media='all' />
<link rel='stylesheet' id='responsive-menu-pro-font-awesome-css' href='https://use.fontawesome.com/releases/v5.2.0/css/all.css' type='text/css' media='all' />
<link rel='stylesheet' id='sp-front-css' href='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/css/front.min.css?ver=1.852' type='text/css' media='all' />
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-includes/js/jquery/jquery.min.js?ver=3.5.1' id='jquery-core-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" id='search-filter-plugin-build-js-extra'>
/* <![CDATA[ */
var SF_LDATA = {"ajax_url":"https:\/\/www.instana.com\/wp-admin\/admin-ajax.php","home_url":"https:\/\/www.instana.com\/","extensions":[]};
/* ]]> */
</script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/plugins/search-filter-pro/public/assets/js/search-filter-build.min.js?ver=2.5.6' id='search-filter-plugin-build-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/plugins/search-filter-pro/public/assets/js/chosen.jquery.min.js?ver=2.5.6' id='search-filter-plugin-chosen-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/js/jquery.min.js?ver=5.7.1' id='jquery-min-js-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/js/popper.min.js?ver=5.7.1' id='popper-min-js-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/js/bootstrap.min.js?ver=5.7.1' id='bootstrap-js-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/plugins/responsive-menu-pro/public/js/jquery.touchSwipe.min.js' id='responsive-menu-pro-jquery-touchswipe-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/plugins/responsive-menu-pro/public/js/noscroll.js' id='responsive-menu-pro-noscroll-js'></script>
<link rel="https://api.w.org/" href="https://www.instana.com/wp-json/" /><link rel="alternate" type="application/json" href="https://www.instana.com/wp-json/wp/v2/posts/5927" /><link rel="EditURI" type="application/rsd+xml" title="RSD" href="https://www.instana.com/xmlrpc.php?rsd" />
<link rel="wlwmanifest" type="application/wlwmanifest+xml" href="https://www.instana.com/wp-includes/wlwmanifest.xml" />
<meta name="generator" content="WordPress 5.7.1" />
<link rel='shortlink' href='https://www.instana.com/?p=5927' />
<link rel="alternate" type="application/json+oembed" href="https://www.instana.com/wp-json/oembed/1.0/embed?url=https%3A%2F%2Fwww.instana.com%2Fblog%2Fwriting-a-kubernetes-operator-in-java-part-3%2F" />
<link rel="alternate" type="text/xml+oembed" href="https://www.instana.com/wp-json/oembed/1.0/embed?url=https%3A%2F%2Fwww.instana.com%2Fblog%2Fwriting-a-kubernetes-operator-in-java-part-3%2F&#038;format=xml" />
<style id="ctcc-css" type="text/css" media="screen">#catapult-cookie-bar{box-sizing:border-box;max-height:0;opacity:0;z-index:99999;overflow:hidden;color:#fff;position:fixed;left:0;bottom:0;width:100%;background-color:#0289cc}#catapult-cookie-bar a{color:#fbcf00}#catapult-cookie-bar .x_close span{background-color:#fff}button#catapultCookie{background:;color:#fff;border:0;padding:6px 9px;border-radius:3px}#catapult-cookie-bar h3{color:#fff}.has-cookie-bar #catapult-cookie-bar{opacity:1;max-height:999px;min-height:30px}</style> <script type="4e1c172490f29109ad76a1a3-text/javascript">
			document.documentElement.className = document.documentElement.className.replace( 'no-js', 'js' );
		</script>
<style>.no-js img.lazyload{display:none}figure.wp-block-image img.lazyloading{min-width:150px}.lazyload{opacity:0}.lazyloading{border:0!important;opacity:1;background:rgba(255,255,255,0) url(https://www.instana.com/wp-content/plugins/wp-smush-pro/app/assets/images/smush-lazyloader-4.gif) no-repeat center!important;background-size:16px auto!important;min-width:16px}</style>

<script data-type="lazy" data-src="data:text/javascript;base64,KGZ1bmN0aW9uKHcsZCxzLGwsaSl7d1tsXT13W2xdfHxbXTt3W2xdLnB1c2goeydndG0uc3RhcnQnOgpuZXcgRGF0ZSgpLmdldFRpbWUoKSxldmVudDonZ3RtLmpzJ30pO3ZhciBmPWQuZ2V0RWxlbWVudHNCeVRhZ05hbWUocylbMF0sCmo9ZC5jcmVhdGVFbGVtZW50KHMpLGRsPWwhPSdkYXRhTGF5ZXInPycmbD0nK2w6Jyc7ai5hc3luYz10cnVlO2ouc3JjPQonaHR0cHM6Ly93d3cuZ29vZ2xldGFnbWFuYWdlci5jb20vZ3RtLmpzP2lkPScraStkbDtmLnBhcmVudE5vZGUuaW5zZXJ0QmVmb3JlKGosZik7Cn0pKHdpbmRvdyxkb2N1bWVudCwnc2NyaXB0JywnZGF0YUxheWVyJywnR1RNLVdCSFBDRzcnKTs=" type="4e1c172490f29109ad76a1a3-text/javascript"></script>

<meta name="generator" content="Powered by WPBakery Page Builder - drag and drop page builder for WordPress." />
<link rel="icon" href="https://www.instana.com/media/cropped-android-chrome-512x512-2-32x32.png" sizes="32x32" />
<link rel="icon" href="https://www.instana.com/media/cropped-android-chrome-512x512-2-192x192.png" sizes="192x192" />
<link rel="apple-touch-icon" href="https://www.instana.com/media/cropped-android-chrome-512x512-2-180x180.png" />
<meta name="msapplication-TileImage" content="https://www.instana.com/media/cropped-android-chrome-512x512-2-270x270.png" />
<style>button#responsive-menu-pro-button,#responsive-menu-pro-container{display:none;-webkit-text-size-adjust:100%}#responsive-menu-pro-container{z-index:99998}@media screen and (max-width:1150px){#responsive-menu-pro-container{display:block;position:fixed;top:0;bottom:0;padding-bottom:5px;margin-bottom:-5px;outline:1px solid transparent;overflow-y:auto;overflow-x:hidden}#responsive-menu-pro-container .responsive-menu-pro-search-box{width:100%;padding:0 2%;border-radius:2px;height:50px;-webkit-appearance:none}#responsive-menu-pro-container.push-left,#responsive-menu-pro-container.slide-left{transform:translateX(-100%);-ms-transform:translateX(-100%);-webkit-transform:translateX(-100%);-moz-transform:translateX(-100%)}.responsive-menu-pro-open #responsive-menu-pro-container.push-left,.responsive-menu-pro-open #responsive-menu-pro-container.slide-left{transform:translateX(0);-ms-transform:translateX(0);-webkit-transform:translateX(0);-moz-transform:translateX(0)}#responsive-menu-pro-container.push-top,#responsive-menu-pro-container.slide-top{transform:translateY(-100%);-ms-transform:translateY(-100%);-webkit-transform:translateY(-100%);-moz-transform:translateY(-100%)}.responsive-menu-pro-open #responsive-menu-pro-container.push-top,.responsive-menu-pro-open #responsive-menu-pro-container.slide-top{transform:translateY(0);-ms-transform:translateY(0);-webkit-transform:translateY(0);-moz-transform:translateY(0)}#responsive-menu-pro-container.push-right,#responsive-menu-pro-container.slide-right{transform:translateX(100%);-ms-transform:translateX(100%);-webkit-transform:translateX(100%);-moz-transform:translateX(100%)}.responsive-menu-pro-open #responsive-menu-pro-container.push-right,.responsive-menu-pro-open #responsive-menu-pro-container.slide-right{transform:translateX(0);-ms-transform:translateX(0);-webkit-transform:translateX(0);-moz-transform:translateX(0)}#responsive-menu-pro-container.push-bottom,#responsive-menu-pro-container.slide-bottom{transform:translateY(100%);-ms-transform:translateY(100%);-webkit-transform:translateY(100%);-moz-transform:translateY(100%)}.responsive-menu-pro-open #responsive-menu-pro-container.push-bottom,.responsive-menu-pro-open #responsive-menu-pro-container.slide-bottom{transform:translateY(0);-ms-transform:translateY(0);-webkit-transform:translateY(0);-moz-transform:translateY(0)}#responsive-menu-pro-container,#responsive-menu-pro-container:before,#responsive-menu-pro-container:after,#responsive-menu-pro-container *,#responsive-menu-pro-container *:before,#responsive-menu-pro-container *:after{box-sizing:border-box;margin:0;padding:0}#responsive-menu-pro-container #responsive-menu-pro-search-box,#responsive-menu-pro-container #responsive-menu-pro-additional-content,#responsive-menu-pro-container #responsive-menu-pro-title{padding:25px 5%}#responsive-menu-pro-container #responsive-menu-pro,#responsive-menu-pro-container #responsive-menu-pro ul{width:100%}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu{display:none}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu.responsive-menu-pro-submenu-open{display:block}#responsive-menu-pro-container li.responsive-menu-pro-item{width:100%;list-style:none}#responsive-menu-pro-container li.responsive-menu-pro-item a{width:100%;display:block;text-decoration:none;position:relative}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a{padding:0 5%}#responsive-menu-pro-container .responsive-menu-pro-submenu li.responsive-menu-pro-item a{padding:0 5%}#responsive-menu-pro-container li.responsive-menu-pro-item a .glyphicon,#responsive-menu-pro-container li.responsive-menu-pro-item a .fab,#responsive-menu-pro-container li.responsive-menu-pro-item a .fas{margin-right:15px}#responsive-menu-pro-container li.responsive-menu-pro-item a .responsive-menu-pro-subarrow{position:absolute;top:0;bottom:0;text-align:center;overflow:hidden}#responsive-menu-pro-container li.responsive-menu-pro-item a .responsive-menu-pro-subarrow .glyphicon,#responsive-menu-pro-container li.responsive-menu-pro-item a .responsive-menu-pro-subarrow .fab,#responsive-menu-pro-container li.responsive-menu-pro-item a .responsive-menu-pro-subarrow .fas{margin-right:0}button#responsive-menu-pro-button .responsive-menu-pro-button-icon-inactive{display:none}button#responsive-menu-pro-button{z-index:99999;display:none;overflow:hidden;outline:none}button#responsive-menu-pro-button img{max-width:100%}.responsive-menu-pro-label{display:inline-block;font-weight:600;margin:0 5px;vertical-align:middle;pointer-events:none}.responsive-menu-pro-accessible{display:inline-block}.responsive-menu-pro-accessible .responsive-menu-pro-box{display:inline-block;vertical-align:middle}.responsive-menu-pro-label.responsive-menu-pro-label-top,.responsive-menu-pro-label.responsive-menu-pro-label-bottom{display:block;margin:0 auto}button#responsive-menu-pro-button{padding:0 0;display:inline-block;cursor:pointer;transition-property:opacity,filter;transition-duration:0.15s;transition-timing-function:linear;font:inherit;color:inherit;text-transform:none;background-color:transparent;border:0;margin:0}.responsive-menu-pro-box{width:25px;height:19px;display:inline-block;position:relative}.responsive-menu-pro-inner{display:block;top:50%;margin-top:-1.5px}.responsive-menu-pro-inner,.responsive-menu-pro-inner::before,.responsive-menu-pro-inner::after{width:25px;height:3px;background-color:rgba(0,179,179,1);border-radius:4px;position:absolute;transition-property:transform;transition-duration:0.15s;transition-timing-function:ease}.responsive-menu-pro-open .responsive-menu-pro-inner,.responsive-menu-pro-open .responsive-menu-pro-inner::before,.responsive-menu-pro-open .responsive-menu-pro-inner::after{background-color:rgba(0,179,179,1)}button#responsive-menu-pro-button:hover .responsive-menu-pro-inner,button#responsive-menu-pro-button:hover .responsive-menu-pro-inner::before,button#responsive-menu-pro-button:hover .responsive-menu-pro-inner::after,button#responsive-menu-pro-button:hover .responsive-menu-pro-open .responsive-menu-pro-inner,button#responsive-menu-pro-button:hover .responsive-menu-pro-open .responsive-menu-pro-inner::before,button#responsive-menu-pro-button:hover .responsive-menu-pro-open .responsive-menu-pro-inner::after,button#responsive-menu-pro-button:focus .responsive-menu-pro-inner,button#responsive-menu-pro-button:focus .responsive-menu-pro-inner::before,button#responsive-menu-pro-button:focus .responsive-menu-pro-inner::after,button#responsive-menu-pro-button:focus .responsive-menu-pro-open .responsive-menu-pro-inner,button#responsive-menu-pro-button:focus .responsive-menu-pro-open .responsive-menu-pro-inner::before,button#responsive-menu-pro-button:focus .responsive-menu-pro-open .responsive-menu-pro-inner::after{background-color:rgba(0,179,179,1)}.responsive-menu-pro-inner::before,.responsive-menu-pro-inner::after{content:"";display:block}.responsive-menu-pro-inner::before{top:-8px}.responsive-menu-pro-inner::after{bottom:-8px}.responsive-menu-pro-boring .responsive-menu-pro-inner,.responsive-menu-pro-boring .responsive-menu-pro-inner::before,.responsive-menu-pro-boring .responsive-menu-pro-inner::after{transition-property:none}.responsive-menu-pro-boring.is-active .responsive-menu-pro-inner{transform:rotate(45deg)}.responsive-menu-pro-boring.is-active .responsive-menu-pro-inner::before{top:0;opacity:0}.responsive-menu-pro-boring.is-active .responsive-menu-pro-inner::after{bottom:0;transform:rotate(-90deg)}button#responsive-menu-pro-button{width:55px;height:55px;position:fixed;top:15px;right:5%;display:inline-block;transition:transform 0.5s,background-color 0.5s;background:rgba(255,255,255,1)}.responsive-menu-pro-open button#responsive-menu-pro-button:hover,.responsive-menu-pro-open button#responsive-menu-pro-button:focus,button#responsive-menu-pro-button:hover,button#responsive-menu-pro-button:focus{background:rgba(255,255,255,1)}.responsive-menu-pro-open button#responsive-menu-pro-button{background:rgba(255,255,255,1)}button#responsive-menu-pro-button .responsive-menu-pro-box{color:rgba(0,179,179,1);pointer-events:none}.responsive-menu-pro-open button#responsive-menu-pro-button .responsive-menu-pro-box{color:rgba(0,179,179,1)}.responsive-menu-pro-label{color:#fff;font-size:14px;line-height:13px;pointer-events:none}.responsive-menu-pro-label .responsive-menu-pro-button-text-open{display:none}.responsive-menu-pro-fade-top #responsive-menu-pro-container,.responsive-menu-pro-fade-left #responsive-menu-pro-container,.responsive-menu-pro-fade-right #responsive-menu-pro-container,.responsive-menu-pro-fade-bottom #responsive-menu-pro-container{display:none}#responsive-menu-pro-container{width:100%;left:0;background:rgba(255,255,255,1);transition:transform 0.5s;text-align:left}#responsive-menu-pro-container #responsive-menu-pro-wrapper{background:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro-additional-content{color:rgba(255,255,255,1)}#responsive-menu-pro-container .responsive-menu-pro-search-box{background:#fff;border:2px solid #dadada;color:#333}#responsive-menu-pro-container .responsive-menu-pro-search-box:-ms-input-placeholder{color:#c7c7cd}#responsive-menu-pro-container .responsive-menu-pro-search-box::-webkit-input-placeholder{color:#c7c7cd}#responsive-menu-pro-container .responsive-menu-pro-search-box:-moz-placeholder{color:#c7c7cd;opacity:1}#responsive-menu-pro-container .responsive-menu-pro-search-box::-moz-placeholder{color:#c7c7cd;opacity:1}#responsive-menu-pro-container .responsive-menu-pro-item-link,#responsive-menu-pro-container #responsive-menu-pro-title,#responsive-menu-pro-container .responsive-menu-pro-subarrow{transition:background-color 0.5s,border-color 0.5s,color 0.5s}#responsive-menu-pro-container #responsive-menu-pro-title{background-color:rgba(255,255,255,1);color:rgba(99,114,130,1);font-size:16px;text-align:left}#responsive-menu-pro-container #responsive-menu-pro-title a{color:rgba(99,114,130,1);font-size:16px;text-decoration:none}#responsive-menu-pro-container #responsive-menu-pro-title a:hover{color:rgba(99,114,130,1)}#responsive-menu-pro-container #responsive-menu-pro-title:hover{background-color:rgba(255,255,255,1);color:rgba(99,114,130,1)}#responsive-menu-pro-container #responsive-menu-pro-title:hover a{color:rgba(99,114,130,1)}#responsive-menu-pro-container #responsive-menu-pro-title #responsive-menu-pro-title-image{display:inline-block;vertical-align:middle;max-width:100%;margin-bottom:15px}#responsive-menu-pro-container #responsive-menu-pro-title #responsive-menu-pro-title-image img{height:25px;max-width:100%}#responsive-menu-pro-container #responsive-menu-pro>li.responsive-menu-pro-item:first-child>a{border-top:1px solid rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item .responsive-menu-pro-item-link{font-size:16px}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a{line-height:40px;border-bottom:1px solid rgba(255,255,255,1);color:rgba(99,114,130,1);background-color:rgba(255,255,255,1);word-wrap:break-word;height:auto;padding-right:40px}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a:hover,#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a:focus{color:rgba(99,114,130,1);background-color:rgba(255,255,255,1);border-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a:hover .responsive-menu-pro-subarrow,#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a:focus .responsive-menu-pro-subarrow{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a:hover .responsive-menu-pro-subarrow.responsive-menu-pro-subarrow-active,#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a:focus .responsive-menu-pro-subarrow.responsive-menu-pro-subarrow-active{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a .responsive-menu-pro-subarrow{right:0;height:39px;line-height:39px;width:40px;color:rgba(99,114,130,1);border-left:1px solid rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a .responsive-menu-pro-subarrow.responsive-menu-pro-subarrow-active{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a .responsive-menu-pro-subarrow.responsive-menu-pro-subarrow-active:hover,#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a .responsive-menu-pro-subarrow.responsive-menu-pro-subarrow-active:focus{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a .responsive-menu-pro-subarrow:hover,#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item a .responsive-menu-pro-subarrow:focus{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item.responsive-menu-pro-current-item>.responsive-menu-pro-item-link{background-color:rgba(255,255,255,1);color:rgba(99,114,130,1);border-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro li.responsive-menu-pro-item.responsive-menu-pro-current-item>.responsive-menu-pro-item-link:hover{background-color:rgba(255,255,255,1);color:rgba(99,114,130,1);border-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item .responsive-menu-pro-item-link{font-size:16px;text-align:left}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a{word-wrap:break-word;height:auto;padding-right:40px;line-height:40px;border-bottom:1px solid rgba(255,255,255,1);color:rgba(99,114,130,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a:hover,#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a:focus{color:rgba(99,114,130,1);background-color:rgba(255,255,255,1);border-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a:hover .responsive-menu-pro-subarrow{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a:hover .responsive-menu-pro-subarrow.responsive-menu-pro-subarrow-active{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a .responsive-menu-pro-subarrow{left:unset;right:0;height:39px;line-height:39px;width:40px;color:rgba(99,114,130,1);border-left:1px solid rgba(255,255,255,1);border-right:unset;background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a .responsive-menu-pro-subarrow.responsive-menu-pro-subarrow-active{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a .responsive-menu-pro-subarrow.responsive-menu-pro-subarrow-active:hover{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item a .responsive-menu-pro-subarrow:hover{color:rgba(99,114,130,1);border-color:rgba(255,255,255,1);background-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item.responsive-menu-pro-current-item>.responsive-menu-pro-item-link{background-color:rgba(255,255,255,1);color:rgba(99,114,130,1);border-color:rgba(255,255,255,1)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu li.responsive-menu-pro-item.responsive-menu-pro-current-item>.responsive-menu-pro-item-link:hover{background-color:rgba(255,255,255,1);color:rgba(99,114,130,1);border-color:rgba(255,255,255,1)}.navbar{display:none!important}#responsive-menu-pro-container #responsive-menu-pro{position:relative;transition:transform 0.5s,height 0.5s}#responsive-menu-pro-container #responsive-menu-pro ul{position:absolute;top:0;left:0;transform:translateX(100%)}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu{display:block}#responsive-menu-pro-container #responsive-menu-pro .responsive-menu-pro-back{padding:0 5%;color:rgba(99,114,130,1);font-size:16px;height:40px;line-height:40px;cursor:pointer;border-bottom:1px solid rgba(255,255,255,1);border-top:1px solid rgba(255,255,255,1);display:none}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu{display:none}#responsive-menu-pro-container #responsive-menu-pro ul.responsive-menu-pro-submenu.responsive-menu-pro-subarrow-active,#responsive-menu-pro-container #responsive-menu-pro .responsive-menu-pro-subarrow-active>.responsive-menu-pro-back{display:block}}#responsive-menu-pro-header{width:100%;padding:0 5%;box-sizing:border-box;top:0;right:0;left:0;display:none;z-index:99998}#responsive-menu-pro-header .responsive-menu-pro-header-box{display:inline-block}#responsive-menu-pro-header .responsive-menu-pro-header-box,#responsive-menu-pro-header .responsive-menu-pro-header-box img{vertical-align:middle;max-width:100%}#responsive-menu-pro-header #responsive-menu-pro-header-bar-logo img{height:33px}#responsive-menu-pro-header button#responsive-menu-pro-button{position:relative;margin:0;left:auto;right:auto;bottom:auto}#responsive-menu-pro-header .responsive-menu-pro-header-box{margin-right:2%}@media screen and (max-width:1025px){#responsive-menu-pro-header{position:fixed;background-color:#fff;height:80px;color:#fff;display:block;font-size:14px}#responsive-menu-pro-header .responsive-menu-pro-header-bar-item{line-height:80px}#responsive-menu-pro-header a{color:#fff;text-decoration:none}}.btn.btn-freetrial-s{background-color:rgb(23,161,230);border-width:2px;border-color:rgb(23,161,230);color:#fff;border-radius:6px;padding:8px 35px 8px 35px!important;font-size:16px;font-family:"Pluto Sans Condensed"}</style><script type="4e1c172490f29109ad76a1a3-text/javascript">jQuery(document).ready(function($) {

    var ResponsiveMenuPro = {
        trigger: '#responsive-menu-pro-button',
        animationSpeed:500,
        breakpoint:1150,        isOpen: false,
        activeClass: 'is-active',
        container: '#responsive-menu-pro-container',
        openClass: 'responsive-menu-pro-open',
        activeArrow: '<span class="fas fa-angle-left"></span>',
        inactiveArrow: '<span class="fas fa-angle-right"></span>',
        wrapper: '#responsive-menu-pro-wrapper',
        linkElement: '.responsive-menu-pro-item-link',
        subMenuTransitionTime:200,
        originalHeight: '',
        openMenu: function() {
            $(this.trigger).addClass(this.activeClass);
            $('html').addClass(this.openClass);
            $('.responsive-menu-pro-button-icon-active').hide();
            $('.responsive-menu-pro-button-icon-inactive').show();                this.setWrapperTranslate();                var self = this;
                if($(window).width() <= self.breakpoint) {
                    $('#responsive-menu-pro').promise().done(function () {
                        self.originalHeight = $('#responsive-menu-pro').height();
                        $('#responsive-menu-pro').css({'height': self.originalHeight});
                    });
                }
            this.isOpen = true;
        },
        closeMenu: function() {
            $(this.trigger).removeClass(this.activeClass);
            $('html').removeClass(this.openClass);
            $('.responsive-menu-pro-button-icon-inactive').hide();
            $('.responsive-menu-pro-button-icon-active').show();                this.clearWrapperTranslate();
            $("#responsive-menu-pro > li").removeAttr('style');
            this.isOpen = false;
        },        triggerMenu: function() {
            this.isOpen ? this.closeMenu() : this.openMenu();
        },            backUpSlide: function(backButton) {
                translate_to = parseInt($('#responsive-menu-pro')[0].style.transform.replace(/^\D+/g, '')) - 100;
                $('#responsive-menu-pro').css({'transform': 'translateX(-' + translate_to + '%)'});
                var previous_submenu_height = $(backButton).parent('ul').parent('li').parent('.responsive-menu-pro-submenu').height();
                if(!previous_submenu_height) {
                    $('#responsive-menu-pro').css({'height': this.originalHeight});
                } else {
                    $('#responsive-menu-pro').css({'height': previous_submenu_height + 'px'});
                }
            },
        triggerSubArrow: function(subarrow) {
            var sub_menu = $(subarrow).parent().siblings('.responsive-menu-pro-submenu');
            var self = this;                if($(window).width() <= self.breakpoint) {
                    $('.responsive-menu-pro-subarrow-active').removeClass('responsive-menu-pro-subarrow-active');
                    sub_menu.addClass('responsive-menu-pro-subarrow-active');
                    sub_menu.parentsUntil('#responsive-menu-pro').addClass('responsive-menu-pro-subarrow-active');
                    current_depth = $(subarrow).parent().parent().parent().data('depth');
                    current_depth = typeof current_depth == 'undefined' ? 1 : current_depth;
                    translation_amount = current_depth * 100;
                    $('#responsive-menu-pro').css({'transform': 'translateX(-' + translation_amount + '%)'});
                    $('#responsive-menu-pro').css({'height': sub_menu.height() + 'px'});
                }
        },
        menuHeight: function() {
            return $(this.container).height();
        },
        menuWidth: function() {
            return $(this.container).width();
        },
        wrapperHeight: function() {
            return $(this.wrapper).height();
        },            setWrapperTranslate: function() {
                switch('left') {
                    case 'left':
                        translate = 'translateX(' + this.menuWidth() + 'px)'; break;
                    case 'right':
                        translate = 'translateX(-' + this.menuWidth() + 'px)'; break;
                    case 'top':
                        translate = 'translateY(' + this.wrapperHeight() + 'px)'; break;
                    case 'bottom':
                        translate = 'translateY(-' + this.menuHeight() + 'px)'; break;
                }            },
            clearWrapperTranslate: function() {
                var self = this;            },
        init: function() {

            var self = this;
                        $('#responsive-menu-pro-container').swipe({
                            swipe:function(event, direction, distance, duration, fingerCount, fingerData) {
                                if($(window).width() < self.breakpoint) {
                                    if (direction == 'left') {
                                        self.closeMenu();
                                    }
                                }
                            },
                            threshold: 25,                                allowPageScroll: "vertical",                            excludedElements: "button, input, select, textarea, a, .noSwipe, .responsive-menu-pro-search-box"
                        });
            $(this.trigger).on('click', function(e){
                e.stopPropagation();
                self.triggerMenu();
            });

            $(this.trigger).mouseup(function(){
                $(self.trigger).blur();
            });

            $('.responsive-menu-pro-subarrow').on('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                self.triggerSubArrow(this);
            });

            $(window).resize(function() {
                if($(window).width() >= self.breakpoint) {
                    if(self.isOpen){
                        self.closeMenu();
                    }
                    $('#responsive-menu-pro, .responsive-menu-pro-submenu').removeAttr('style');
                } else {                        if($('.responsive-menu-pro-open').length > 0){
                            self.setWrapperTranslate();
                        }                }
            });                $('.responsive-menu-pro-back').on('click', function() {
                    self.backUpSlide(this);
                });
             /* Desktop menu : hide on scroll down / show on scroll Up */            $(this.trigger).mousedown(function(e){
                e.preventDefault();
                e.stopPropagation();
            });            if (jQuery('#responsive-menu-pro-button').css('display') != 'none') {

                $('#responsive-menu-pro-button,#responsive-menu-pro a.responsive-menu-pro-item-link,#responsive-menu-pro-wrapper input').focus( function() {
                    $(this).addClass('is-active');
                    $('html').addClass('responsive-menu-pro-open');
                    $('#responsive-menu-pro li').css({"opacity": "1", "margin-left": "0"});
                });

                $('a,input,button').focusout( function( event ) {
                    if ( ! $(this).parents('#responsive-menu-pro-container').length ) {
                        $('html').removeClass('responsive-menu-pro-open');
                        $('#responsive-menu-pro-button').removeClass('is-active');
                    }
                });
            } else {            }            $('#responsive-menu-pro a.responsive-menu-pro-item-link').keydown(function(event) {
                if ( [13,27,32,35,36,37,38,39,40].indexOf( event.keyCode) == -1) {
                    return;
                }
                var link = $(this);
                switch(event.keyCode) {
                    case 13:                        link.click();
                        break;
                    case 27:                        var dropdown = link.parent('li').parents('.responsive-menu-pro-submenu');
                        if ( dropdown.length > 0 ) {
                            dropdown.hide();
                            dropdown.prev().focus();
                        }
                        break;
                    case 32:                        var dropdown = link.parent('li').find('.responsive-menu-pro-submenu');
                        if ( dropdown.length > 0 ) {
                            dropdown.show();
                            dropdown.find('a, input, button, textarea').filter(':visible').first().focus();
                        }
                        break;
                    case 35:                        var dropdown = link.parent('li').find('.responsive-menu-pro-submenu');
                        if ( dropdown.length > 0 ) {
                            dropdown.hide();
                        }
                        $(this).parents('#responsive-menu-pro').find('a.responsive-menu-pro-item-link').filter(':visible').last().focus();
                        break;
                    case 36:                        var dropdown = link.parent('li').find('.responsive-menu-pro-submenu');
                        if( dropdown.length > 0 ) {
                            dropdown.hide();
                        }

                        $(this).parents('#responsive-menu-pro').find('a.responsive-menu-pro-item-link').filter(':visible').first().focus();
                        break;
                    case 37:
                        event.preventDefault();
                        event.stopPropagation();                        if ( link.parent('li').prevAll('li').filter(':visible').first().length == 0) {
                            link.parent('li').nextAll('li').filter(':visible').last().find('a').first().focus();
                        } else {
                            link.parent('li').prevAll('li').filter(':visible').first().find('a').first().focus();
                        }                        if ( link.parent('li').children('.responsive-menu-pro-submenu').length ) {
                            link.parent('li').children('.responsive-menu-pro-submenu').hide();
                        }
                        break;
                    case 38:                        var dropdown = link.parent('li').find('.responsive-menu-pro-submenu');
                        if( dropdown.length > 0 ) {
                            event.preventDefault();
                            event.stopPropagation();
                            dropdown.find('a, input, button, textarea').filter(':visible').first().focus();
                        } else {
                            if ( link.parent('li').prevAll('li').filter(':visible').first().length == 0) {
                                link.parent('li').nextAll('li').filter(':visible').last().find('a').first().focus();
                            } else {
                                link.parent('li').prevAll('li').filter(':visible').first().find('a').first().focus();
                            }
                        }
                        break;
                    case 39:
                        event.preventDefault();
                        event.stopPropagation();                        if( link.parent('li').nextAll('li').filter(':visible').first().length == 0) {
                            link.parent('li').prevAll('li').filter(':visible').last().find('a').first().focus();
                        } else {
                            link.parent('li').nextAll('li').filter(':visible').first().find('a').first().focus();
                        }                        if ( link.parent('li').children('.responsive-menu-pro-submenu').length ) {
                            link.parent('li').children('.responsive-menu-pro-submenu').hide();
                        }
                        break;
                    case 40:                        var dropdown = link.parent('li').find('.responsive-menu-pro-submenu');
                        if ( dropdown.length > 0 ) {
                            event.preventDefault();
                            event.stopPropagation();
                            dropdown.find('a, input, button, textarea').filter(':visible').first().focus();
                        } else {
                            if( link.parent('li').nextAll('li').filter(':visible').first().length == 0) {
                                link.parent('li').prevAll('li').filter(':visible').last().find('a').first().focus();
                            } else {
                                link.parent('li').nextAll('li').filter(':visible').first().find('a').first().focus();
                            }
                        }
                        break;
                    }
            });

        }
    };
    ResponsiveMenuPro.init();
});
</script><script type="application/ld+json">
{
  "@context": "http://schema.org",
  "@type": "Organization",
  "name": "Instana",
  "alternateName": "Instana D.O.O",
  "url": "https://www.instana.com/",
  "logo": "https://www.instana.com/media/instana-logo-email-signature.png",
  "sameAs": [
    "https://www.facebook.com/InstanaHQ",
    "https://twitter.com/InstanaHQ",
    "https://www.linkedin.com/company/10082535",
    "https://www.meetup.com/Instana-Bay-Area-Meetup-Group/",
    "https://en.wikipedia.org/wiki/Instana"
  ]
}
</script>
<!--[if lte IE 8]>
<script charset="utf-8" type="text/javascript" src="//js.hsforms.net/forms/v2-legacy.js"></script>
<![endif]-->
<script charset="utf-8" type="4e1c172490f29109ad76a1a3-text/javascript" src="//js.hsforms.net/forms/v2.js"></script>

<script type="4e1c172490f29109ad76a1a3-text/javascript" data-type="lazy" data-src="data:text/javascript;base64,DQogICAgKGZ1bmN0aW9uKGQscyxpLHIpIHsNCiAgICAgICAgaWYgKGQuZ2V0RWxlbWVudEJ5SWQoaSkpe3JldHVybjt9DQogICAgICAgIHZhciBuPWQuY3JlYXRlRWxlbWVudChzKSxlPWQuZ2V0RWxlbWVudHNCeVRhZ05hbWUocylbMF07DQogICAgICAgIG4uaWQ9aTtuLnNyYz0nLy9qcy5ocy1hbmFseXRpY3MubmV0L2FuYWx5dGljcy8nKyhNYXRoLmNlaWwobmV3IERhdGUoKS9yKSpyKSsnLzcxOTMwMi5qcyc7DQogICAgICAgIGUucGFyZW50Tm9kZS5pbnNlcnRCZWZvcmUobiwgZSk7DQogICAgfSkoZG9jdW1lbnQsInNjcmlwdCIsImhzLWFuYWx5dGljcyIsMzAwMDAwKTsNCg=="></script>


<script type="4e1c172490f29109ad76a1a3-text/javascript">
  (function(s,t,a,n){s[t]||(s[t]=a,n=s[a]=function(){n.q.push(arguments)},
  n.q=[],n.v=2,n.l=1*new Date)})(window,"InstanaEumObject","ineum");

  ineum('reportingUrl', 'https://eum-orange-saas.instana.io');
  ineum('key', 'VN1czu0OQfOBhspcMHlaOw');
  ineum('trackSessions');
</script>
<script defer crossorigin="anonymous" data-type="lazy" data-src="https://eum.instana.io/eum.min.js" type="4e1c172490f29109ad76a1a3-text/javascript"></script>

 <script data-type="lazy" data-src="data:text/javascript;base64,ICAgIChmdW5jdGlvbigpIHsgICAgICAgdmFyIGxvb3BTY3JpcHQgPSBkb2N1bWVudC5jcmVhdGVFbGVtZW50KCdzY3JpcHQnKTsgICAgICAgbG9vcFNjcmlwdC50eXBlID0gJ3RleHQvamF2YXNjcmlwdCc7ICAgICAgIGxvb3BTY3JpcHQuYXN5bmMgPSB0cnVlOyAgICAgICBsb29wU2NyaXB0LnNyYyA9ICdodHRwczovL3YyLmxpc3Rlbmxvb3AuY29tL2xvb3AuYnVuZGxlLmpzJzsgICAgICAgbG9vcFNjcmlwdC5zZXRBdHRyaWJ1dGUoJ2xsLXB1YmxpYy1rZXknLCAnTGFvTmszMmF6ZXl0TUJXQ2dqQ3MnKTsgICAgICAgdmFyIGZpcnN0U2NyaXB0VGFnID0gZG9jdW1lbnQuZ2V0RWxlbWVudHNCeVRhZ05hbWUoJ3NjcmlwdCcpWzBdOyAgICAgICBmaXJzdFNjcmlwdFRhZy5wYXJlbnROb2RlLmluc2VydEJlZm9yZShsb29wU2NyaXB0LCBmaXJzdFNjcmlwdFRhZyk7ICAgICB9KSgpOyAgIA==" type="4e1c172490f29109ad76a1a3-text/javascript"></script>

<script data-type="lazy" data-src="data:text/javascript;base64,DQohZnVuY3Rpb24oZSx0LG4scyx1LGEpe2UudHdxfHwocz1lLnR3cT1mdW5jdGlvbigpe3MuZXhlP3MuZXhlLmFwcGx5KHMsYXJndW1lbnRzKTpzLnF1ZXVlLnB1c2goYXJndW1lbnRzKTsNCn0scy52ZXJzaW9uPScxLjEnLHMucXVldWU9W10sdT10LmNyZWF0ZUVsZW1lbnQobiksdS5hc3luYz0hMCx1LnNyYz0nLy9zdGF0aWMuYWRzLXR3aXR0ZXIuY29tL3V3dC5qcycsDQphPXQuZ2V0RWxlbWVudHNCeVRhZ05hbWUobilbMF0sYS5wYXJlbnROb2RlLmluc2VydEJlZm9yZSh1LGEpKX0od2luZG93LGRvY3VtZW50LCdzY3JpcHQnKTsNCi8vIEluc2VydCBUd2l0dGVyIFBpeGVsIElEIGFuZCBTdGFuZGFyZCBFdmVudCBkYXRhIGJlbG93DQp0d3EoJ2luaXQnLCdudXV3cicpOw0KdHdxKCd0cmFjaycsJ1BhZ2VWaWV3Jyk7DQo=" type="4e1c172490f29109ad76a1a3-text/javascript"></script>

<script type="4e1c172490f29109ad76a1a3-text/javascript">
(function(a, b, c, d, e, m) {
	a['OktopostTrackerObject'] = d;
	a[d] = a[d] || function() {
		(a[d].q = a[d].q || []).push(arguments);
	};
	e = b.createElement('script');
	m = b.getElementsByTagName('script')[0];
	e.async = 1;
	e.src = c;
	m.parentNode.insertBefore(e, m);
})(window, document, 'https://static.oktopost.com/oktrk.js', '_oktrk');
_oktrk('create', '0013ouuc0bhvp4g');
</script><style class="sp-custom-style">div#CybotCookiebotDialog{background-image:url(/media/FreeTrial-light-bg-pattern-01-01.svg);background-repeat:no-repeat}div#CybotCookiebotDialogBody{background-color:#fafbfc}#CybotCookiebotDialog br,#CybotCookiebotDialog div,#CybotCookiebotDialog td{line-height:1.231;font-size:9.5pt!important}#CybotCookiebotDialogBodyContentText a{font-size:9.5pt!important;color:#06b3b3!important;text-decoration:none!important}.ctcc-left-side{color:#fff!important}.header-logo{max-width:150px!important;width:100%;min-width:150px}.fa,.fas{font-family:"FontAwesome"}.btn.btn-freetrial{background-color:rgb(23,161,230)!important;border-width:2px!important;border-color:rgb(23,161,230)!important;color:#fff!important;border-radius:6px!important;padding:8px 35px 8px 35px!important!important;font-size:16px!important;font-family:"Pluto Sans Condensed"!important}.btn.btn-freetrial:hover,.btn.btn-freetrial-s:hover{background-color:#2483b3!important;border-color:#2483b3!important;color:#fff}.admin-bar .fixed-top{top:32px}.home .top-news-bar{position:fixed;z-index:9999;background:#00bfc0;min-height:30px}.home #notifications-bar{color:#fff;font-size:18px;font-weight:600;letter-spacing:1px;text-align:center}.home .fixed-top{top:28px}.home.admin-bar .fixed-top{top:60px!important}.home #responsive-menu-pro-container{top:5%}@media only screen and (max-width:1169px) and (min-width:992px){.home .ht-notification-text{max-width:100%!important}.home .ht-notification-text a{font-size:11px!important;line-height:0}.home #notifications-bar{font-size:11px!important}.home button#responsive-menu-pro-button{top:35px}.home #responsive-menu-pro-header{top:25px}.home.scrolled{overflow:auto}.page-template.scrolled{overflow:auto}}@media only screen and (max-width:991px) and (min-width:768px){.home .ht-notification-text{max-width:100%!important;padding:0}.home .ht-notification-text a{font-size:11px!important;line-height:0}.home #notifications-bar{font-size:11px!important}.home button#responsive-menu-pro-button{top:35px}.home #responsive-menu-pro-header{top:25px}.home.scrolled{overflow:auto}.page-template.scrolled{overflow:auto}}@media screen and (max-width:767px){.home .ht-notification-text a{font-size:11px!important;line-height:0}.home #notifications-bar{font-size:11px!important}.home .ht-notification-text{line-height:20px}.home button#responsive-menu-pro-button{top:5%}.home #responsive-menu-pro-header{top:30px}.home.scrolled{overflow:auto}.page-template.scrolled{overflow:auto}.home .ht-n-top.ht-n-full-width .ht-notification-wrap,.ht-n-bottom.ht-n-full-width .ht-notification-wrap{padding-left:10px;padding-right:10px}.home .ht-n-container_full_width{width:90%;margin:0 auto}}.bg-faded{background:#fff}.ht-notification-wrap{text-align:center;font-weight:600;padding-top:2px!important;padding-bottom:2px!important}.ht-n-close-toggle i{color:#232323;font-weight:600}span.ht-n-open-toggle.ht-n-active{display:none}body.fancybox-active{overflow:visible!important}.instana-cookie{width:100%;flex-direction:column}a.ctcc-more-info-link{display:block;margin-top:0;text-decoration:none!important;font-weight:400;float:right;margin-left:10px}#catapult-cookie-bar h3{font-size:24px}.use_x_close .x_close{top:-10px}.has-cookie-bar #catapult-cookie-bar{opacity:1;max-height:999px;min-height:30px}.has-cookie-bar #catapult-cookie-bar{opacity:1;max-height:999px;min-height:30px;padding:7px 15px 7px 15px}.cookie-bar-block #catapult-cookie-bar{max-height:999px;-webkit-transition:opacity 0.25s;-moz-transition:opacity 0.25s;transition:opacity 0.25s}#catapult-cookie-bar.drop-shadow{-webkit-box-shadow:0 3px 9px 0 rgba(0,0,0,.4);-moz-box-shadow:0 3px 9px 0 rgba(0,0,0,.4);box-shadow:0 3px 9px 0 rgba(0,0,0,.4)}#catapult-cookie-bar.rounded-corners{border-radius:3px}#catapult-cookie-bar{width:100%}a.ctcc-more-info-link:after{content:'\f18e';font-family:FontAwesome;font-size:12px;font-weight:300;line-height:1;margin-left:5px}.cookie-bar-bar .use_x_close .x_close{left:0;right:auto}@media only screen and (max-width:1024px){a.ctcc-more-info-link{float:none;margin-left:0}span.ctcc-left-side{max-width:80%}}@media only screen and (max-width:600px){#catapult-cookie-bar{left:0!important;bottom:0!important;width:100%!important}}#image-shadow a.sp-image-link:after{content:url(http://development.instana.com/media/shadow-img-01.png);text-align:center;margin-left:auto;margin-right:auto;position:relative;top:-54px;z-index:0;display:block;height:10px}.img-responsive{position:relative;z-index:1}@media (max-width:768px){#image-shadow a.sp-image-link:after{display:none!important}}.sim-button{line-height:1;height:auto;text-align:center;margin-right:auto;margin-left:auto;margin-top:10px;max-width:max-content;cursor:pointer;padding-top:1.2rem;padding-bottom:1.2rem;width:auto;padding-left:1rem;padding-right:1rem}.button8{color:rgba(5,123,195,1);-webkit-transition:all 0.5s;-moz-transition:all 0.5s;-o-transition:all 0.5s;transition:all 0.5s;border:1.2px solid rgba(5,123,195,1);position:relative;border-radius:5px}.button8 a{color:rgba(5,123,195,1);text-decoration:none;display:block}.button8:hover{color:rgba(255,255,255,1)!important}.button8 span{z-index:2;display:block;position:relative;width:100%;height:100%;font-weight:600}.button8::before{content:'';position:absolute;top:0;left:0;width:0%;height:100%;z-index:1;opacity:0;background-color:rgba(5,123,195,1);-webkit-transition:all 0.3s;-moz-transition:all 0.3s;-o-transition:all 0.3s;transition:all 0.3s}.button8:hover::before{opacity:1;width:100%}@media (max-width:400px){.button8 span{font-size:12px}}@media screen and (max-width:1280px){.sp-navigation .sp-navigation-dropdown-panel .sp-navigation-dropdown-panel-table .sp-navigation-dropdown-panel-column{display:block}}@media screen and (max-width:1024px){#header .header-navigation .sp-navigation-nav .btn.btn-white-outline a{background-color:transparent;padding-left:0!important;padding-right:0;border:0!important;margin-left:0!important;font-weight:500;padding-top:5px;display:block!important;position:relative!important;width:100%}li.btn-white-outline{padding-right:2px!important}.btn-white-outline .inner-block{max-width:100%}.left-block{text-align:left}span.menu-t-title{text-align:left;color:rgba(255,255,255,.6);font-size:15px;font-weight:300!important;font-family:"Pluto Sans Condensed",sans-serif}.menu-image,.menu-icons{display:none}.btn-white-outline.active{box-shadow:none!important}}#header .header-navigation.sp-navigation-breakpoint-down .sp-navigation-nav{background-color:#1b3567}li.hover a{background:transparent!important}@media screen and (max-width:1280px){.sp-navigation .sp-navigation-dropdown-panel .sp-navigation-dropdown-panel-table .sp-navigation-dropdown-panel-column{display:block}}.home .home-post-title h5{min-height:70px!important;margin-bottom:10px!important}.home .home-post-new{min-height:300px!important}.sec-level a{padding:8px 15px 8px 10px!important;font-size:13px;font-weight:300;line-height:1;min-width:260px}.sec-level a:before{content:'\f0a9';display:inline-block;font:normal normal normal 12px/1 FontAwesome!important;font-size:inherit;text-rendering:auto;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;margin-right:5px;color:rgba(5,123,195,.7)}.sec-level a{padding:8px 15px 8px 10px;font-size:12px;font-weight:300;line-height:1;min-width:260px;color:#222!important}@media screen and (max-width:1024px){.sec-level a{color:rgba(255,255,255,.6)!important}.sec-level a:before{color:rgba(255,255,255,.7)!important}.sec-level a{padding:8px 15px 8px 30px!important}}.post-type-archive-webinar h1.h3.m-b-6{font-size:25px;margin-bottom:25px!important}.post-type-archive-webinar h4.item-title{font-size:45px;line-height:.7}.post-type-archive-webinar h4.item-title a{font-size:1.5rem!important;line-height:0;font-weight:500}@media only screen and (max-width:1366px){.inner-block{display:block!important;max-width:200px!important}.left-block{width:100%!important}.b-blok{display:none;height:100%!important;min-height:0px!important}.right-block{width:100%!important}}.single-post .webinar-form{text-align:center}.blog p.more-link{display:none}li#menu-item-6747{padding-left:0}#header .header-top{z-index:9999!important}.blog-inner-text a:hover{text-decoration:underline!important}.blog-inner-text a{font-weight:400}.partner-grid .sp-post-list-items .item-thumbnail img{max-height:85px!important}.header-logo{max-width:150px;width:100%;min-width:150px}.cs-icon-small img{width:40px}.embed-responsive-16by9::before{padding-top:0!important}</style><noscript><style>.wpb_animate_when_almost_visible{opacity:1}</style></noscript>
<style class="sp-custom-style">div#CybotCookiebotDialog{background-image:url(/media/FreeTrial-light-bg-pattern-01-01.svg);background-repeat:no-repeat}div#CybotCookiebotDialogBody{background-color:#fafbfc}#CybotCookiebotDialog br,#CybotCookiebotDialog div,#CybotCookiebotDialog td{line-height:1.231;font-size:9.5pt!important}#CybotCookiebotDialogBodyContentText a{font-size:9.5pt!important;color:#06b3b3!important;text-decoration:none!important}.ctcc-left-side{color:#fff!important}.header-logo{max-width:150px!important;width:100%;min-width:150px}.fa,.fas{font-family:"FontAwesome"}.btn.btn-freetrial{background-color:rgb(23,161,230)!important;border-width:2px!important;border-color:rgb(23,161,230)!important;color:#fff!important;border-radius:6px!important;padding:8px 35px 8px 35px!important!important;font-size:16px!important;font-family:"Pluto Sans Condensed"!important}.btn.btn-freetrial:hover,.btn.btn-freetrial-s:hover{background-color:#2483b3!important;border-color:#2483b3!important;color:#fff}.admin-bar .fixed-top{top:32px}.home .top-news-bar{position:fixed;z-index:9999;background:#00bfc0;min-height:30px}.home #notifications-bar{color:#fff;font-size:18px;font-weight:600;letter-spacing:1px;text-align:center}.home .fixed-top{top:28px}.home.admin-bar .fixed-top{top:60px!important}.home #responsive-menu-pro-container{top:5%}@media only screen and (max-width:1169px) and (min-width:992px){.home .ht-notification-text{max-width:100%!important}.home .ht-notification-text a{font-size:11px!important;line-height:0}.home #notifications-bar{font-size:11px!important}.home button#responsive-menu-pro-button{top:35px}.home #responsive-menu-pro-header{top:25px}.home.scrolled{overflow:auto}.page-template.scrolled{overflow:auto}}@media only screen and (max-width:991px) and (min-width:768px){.home .ht-notification-text{max-width:100%!important;padding:0}.home .ht-notification-text a{font-size:11px!important;line-height:0}.home #notifications-bar{font-size:11px!important}.home button#responsive-menu-pro-button{top:35px}.home #responsive-menu-pro-header{top:25px}.home.scrolled{overflow:auto}.page-template.scrolled{overflow:auto}}@media screen and (max-width:767px){.home .ht-notification-text a{font-size:11px!important;line-height:0}.home #notifications-bar{font-size:11px!important}.home .ht-notification-text{line-height:20px}.home button#responsive-menu-pro-button{top:5%}.home #responsive-menu-pro-header{top:30px}.home.scrolled{overflow:auto}.page-template.scrolled{overflow:auto}.home .ht-n-top.ht-n-full-width .ht-notification-wrap,.ht-n-bottom.ht-n-full-width .ht-notification-wrap{padding-left:10px;padding-right:10px}.home .ht-n-container_full_width{width:90%;margin:0 auto}}.bg-faded{background:#fff}.ht-notification-wrap{text-align:center;font-weight:600;padding-top:2px!important;padding-bottom:2px!important}.ht-n-close-toggle i{color:#232323;font-weight:600}span.ht-n-open-toggle.ht-n-active{display:none}body.fancybox-active{overflow:visible!important}.instana-cookie{width:100%;flex-direction:column}a.ctcc-more-info-link{display:block;margin-top:0;text-decoration:none!important;font-weight:400;float:right;margin-left:10px}#catapult-cookie-bar h3{font-size:24px}.use_x_close .x_close{top:-10px}.has-cookie-bar #catapult-cookie-bar{opacity:1;max-height:999px;min-height:30px}.has-cookie-bar #catapult-cookie-bar{opacity:1;max-height:999px;min-height:30px;padding:7px 15px 7px 15px}.cookie-bar-block #catapult-cookie-bar{max-height:999px;-webkit-transition:opacity 0.25s;-moz-transition:opacity 0.25s;transition:opacity 0.25s}#catapult-cookie-bar.drop-shadow{-webkit-box-shadow:0 3px 9px 0 rgba(0,0,0,.4);-moz-box-shadow:0 3px 9px 0 rgba(0,0,0,.4);box-shadow:0 3px 9px 0 rgba(0,0,0,.4)}#catapult-cookie-bar.rounded-corners{border-radius:3px}#catapult-cookie-bar{width:100%}a.ctcc-more-info-link:after{content:'\f18e';font-family:FontAwesome;font-size:12px;font-weight:300;line-height:1;margin-left:5px}.cookie-bar-bar .use_x_close .x_close{left:0;right:auto}@media only screen and (max-width:1024px){a.ctcc-more-info-link{float:none;margin-left:0}span.ctcc-left-side{max-width:80%}}@media only screen and (max-width:600px){#catapult-cookie-bar{left:0!important;bottom:0!important;width:100%!important}}#image-shadow a.sp-image-link:after{content:url(http://development.instana.com/media/shadow-img-01.png);text-align:center;margin-left:auto;margin-right:auto;position:relative;top:-54px;z-index:0;display:block;height:10px}.img-responsive{position:relative;z-index:1}@media (max-width:768px){#image-shadow a.sp-image-link:after{display:none!important}}.sim-button{line-height:1;height:auto;text-align:center;margin-right:auto;margin-left:auto;margin-top:10px;max-width:max-content;cursor:pointer;padding-top:1.2rem;padding-bottom:1.2rem;width:auto;padding-left:1rem;padding-right:1rem}.button8{color:rgba(5,123,195,1);-webkit-transition:all 0.5s;-moz-transition:all 0.5s;-o-transition:all 0.5s;transition:all 0.5s;border:1.2px solid rgba(5,123,195,1);position:relative;border-radius:5px}.button8 a{color:rgba(5,123,195,1);text-decoration:none;display:block}.button8:hover{color:rgba(255,255,255,1)!important}.button8 span{z-index:2;display:block;position:relative;width:100%;height:100%;font-weight:600}.button8::before{content:'';position:absolute;top:0;left:0;width:0%;height:100%;z-index:1;opacity:0;background-color:rgba(5,123,195,1);-webkit-transition:all 0.3s;-moz-transition:all 0.3s;-o-transition:all 0.3s;transition:all 0.3s}.button8:hover::before{opacity:1;width:100%}@media (max-width:400px){.button8 span{font-size:12px}}@media screen and (max-width:1280px){.sp-navigation .sp-navigation-dropdown-panel .sp-navigation-dropdown-panel-table .sp-navigation-dropdown-panel-column{display:block}}@media screen and (max-width:1024px){#header .header-navigation .sp-navigation-nav .btn.btn-white-outline a{background-color:transparent;padding-left:0!important;padding-right:0;border:0!important;margin-left:0!important;font-weight:500;padding-top:5px;display:block!important;position:relative!important;width:100%}li.btn-white-outline{padding-right:2px!important}.btn-white-outline .inner-block{max-width:100%}.left-block{text-align:left}span.menu-t-title{text-align:left;color:rgba(255,255,255,.6);font-size:15px;font-weight:300!important;font-family:"Pluto Sans Condensed",sans-serif}.menu-image,.menu-icons{display:none}.btn-white-outline.active{box-shadow:none!important}}#header .header-navigation.sp-navigation-breakpoint-down .sp-navigation-nav{background-color:#1b3567}li.hover a{background:transparent!important}@media screen and (max-width:1280px){.sp-navigation .sp-navigation-dropdown-panel .sp-navigation-dropdown-panel-table .sp-navigation-dropdown-panel-column{display:block}}.home .home-post-title h5{min-height:70px!important;margin-bottom:10px!important}.home .home-post-new{min-height:300px!important}.sec-level a{padding:8px 15px 8px 10px!important;font-size:13px;font-weight:300;line-height:1;min-width:260px}.sec-level a:before{content:'\f0a9';display:inline-block;font:normal normal normal 12px/1 FontAwesome!important;font-size:inherit;text-rendering:auto;-webkit-font-smoothing:antialiased;-moz-osx-font-smoothing:grayscale;margin-right:5px;color:rgba(5,123,195,.7)}.sec-level a{padding:8px 15px 8px 10px;font-size:12px;font-weight:300;line-height:1;min-width:260px;color:#222!important}@media screen and (max-width:1024px){.sec-level a{color:rgba(255,255,255,.6)!important}.sec-level a:before{color:rgba(255,255,255,.7)!important}.sec-level a{padding:8px 15px 8px 30px!important}}.post-type-archive-webinar h1.h3.m-b-6{font-size:25px;margin-bottom:25px!important}.post-type-archive-webinar h4.item-title{font-size:45px;line-height:.7}.post-type-archive-webinar h4.item-title a{font-size:1.5rem!important;line-height:0;font-weight:500}@media only screen and (max-width:1366px){.inner-block{display:block!important;max-width:200px!important}.left-block{width:100%!important}.b-blok{display:none;height:100%!important;min-height:0px!important}.right-block{width:100%!important}}.single-post .webinar-form{text-align:center}.blog p.more-link{display:none}li#menu-item-6747{padding-left:0}#header .header-top{z-index:9999!important}.blog-inner-text a:hover{text-decoration:underline!important}.blog-inner-text a{font-weight:400}.partner-grid .sp-post-list-items .item-thumbnail img{max-height:85px!important}.header-logo{max-width:150px;width:100%;min-width:150px}.cs-icon-small img{width:40px}.embed-responsive-16by9::before{padding-top:0!important}</style> <style>.btn.btn-freetrial{background-color:rgb(23,161,230);border-width:2px;border-color:rgb(23,161,230);color:#fff!important;border-radius:6px;padding:8px 35px 8px 35px!important;font-size:16px;font-family:"Pluto Sans Condensed"}.btn-menu{background-color:rgb(23,161,230)!important;padding:6px 15px 6px!important;line-height:1!important}.btn-menu:hover{background-color:#2483B3}li.astm-search-menu.is-menu.popup{padding-left:0;color:#637282;filter:opacity(.65)}li.astm-search-menu.is-menu.popup:before{content:'|';padding-right:10px}.navbar-light .navbar-text a{color:#637282;font-size:14px!important;font-family:"Pluto Sans Condensed";text-decoration:none!important;line-height:1!important}ul#menu-top-menu .menu-item{margin-right:13px}.btn-menu a{color:#fff!important;font-size:14px!important}ul#menu-top-menu{list-style-type:none;padding-left:0;margin-bottom:0;justify-content:flex-end!important;align-items:center}.right-menu{display:flex}.navbar-text{margin-top:0!important}.right-menu,.right-menu-inner{display:flex;width:100%}.doc-link,.login-top-link,.btn-search{padding:.5rem;margin-left:1rem}.trial-button-header{justify-content:end}ul#menu-top-menu{list-style-type:none;padding-left:0;margin-bottom:0;justify-content:end;align-items:center}.scrolled{transition:0.3s}.scrolled .navbar{box-shadow:0 2px 25px 2px rgba(0,0,0,.1);transition:0.3s}.scrolled #responsive-menu-pro-header{box-shadow:0 2px 25px 2px rgba(0,0,0,.1)}.top-search{color:#637282;font-weight:100}.menu-search-box{background:#fff;position:absolute;top:45px;right:0;width:300px;height:50px;line-height:50px;box-shadow:0 0 10px rgba(0,0,0,.3);display:none;border:0;border-radius:10px;z-index:999}.menu-search-box:before{background-color:#fff;content:"\00a0";display:block;height:12px;position:absolute;top:0;transform:rotate(29deg) skew(-35deg);-moz-transform:rotate(29deg) skew(-35deg);-ms-transform:rotate(29deg) skew(-35deg);-o-transform:rotate(29deg) skew(-35deg);-webkit-transform:rotate(118deg) skew(-35deg);width:25px;right:8px;box-shadow:0 0 10px rgba(0,0,0,.3);z-index:-1;overflow:hidden}.menu-search-box input[type="text"]{width:100%;padding:5px 10px;outline:none;border:0;border-radius:10px;height:50px!important}.menu-search-box .form-control:focus{box-shadow:none}#menu-item-12017:before{content:'|';color:#637282;padding-right:10px}.menu-search-box .form-control:-internal-autofill-selected,.menu-search-box .form-control:-webkit-autofill,.menu-search-box .form-control:focus{background-color:white!important}#wp-admin-bar-search{display:none}@media only screen and (min-width:1025px){.header-logo{min-width:175px!important}}#mega-menu-wrap-primary .mega-sub-menu{padding:15px 0!important}#mega-menu-wrap-primary .mega-menu-column .mega-sub-menu{width:100%!important;padding:0!important}#mega-menu-wrap-primary .mega-sub-menu .mega-menu-link{padding:3px 0!important;font-size:18px!important;color:#49525b!important}#mega-menu-wrap-primary .mega-sub-menu .mega-menu-link:hover{text-decoration:underline!important;font-weight:700!important}#mega-menu-wrap-primary .li.mega-menu-item{color:#49525b!important}#mega-menu-wrap-primary.mega-sub-menu .mega-menu-link:hover{text-decoration:underline!important;font-weight:700!important}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.mega-menu-column>ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link{color:#137abb!important;text-transform:none!important;cursor:default;font-weight:600;font-size:20px!important}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.mega-menu-column>ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link:hover{text-decoration:none!important;font-weight:600!important}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.mega-menu-column>ul.mega-sub-menu>li.mega-menu-item>.mega-sub-menu{padding-top:5px!important}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.kubernetes-dist>ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link{color:#49525b!important;font-weight:600!important;padding-top:45px!important;font-size:18px!important;text-decoration:none!important;text-transform:none!important;font-family:"Pluto Sans Condensed"}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.kubernetes-dist>ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link:hover{text-decoration:underline!important;font-weight:600!important;cursor:pointer!important}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.kubernetes-dist>ul.mega-sub-menu>li.mega-menu-item>.mega-sub-menu{padding-top:0!important}#mega-menu-wrap-primary #mega-menu-item-14398 ul li:nth-child(-n+3) a{font-weight:600!important;font-size:18px!important;text-decoration:none!important;text-transform:none!important;font-family:"Pluto Sans Condensed"}#mega-menu-wrap-primary #mega-menu-item-14398 ul li:nth-child(-n+3):hover,#mega-menu-wrap-primary #mega-menu-item-14398 ul li:nth-child(-n+3) a:hover{text-decoration:underline!important;text-transform:none!important}#mega-menu-wrap-primary #mega-menu-item-14398 ul li:nth-child(n+4),#mega-menu-wrap-primary .kubernetes-dist ul.mega-sub-menu{padding-left:15px!important}#mega-menu-wrap-primary .solution-menu .mega-sub-menu{width:100%!important}#mega-menu-wrap-primary .mega-solutions-menu-item .mega-menu-row ul.mega-sub-menu{width:100%!important}#mega-menu-wrap-primary .resources-menu .mega-menu-link,#mega-menu-wrap-primary .company-menu .mega-menu-link{display:block!important;background:#fff!important;font-family:"Pluto Sans Condensed";font-size:18px!important;font-weight:400!important;padding:0 10px 0 10px!important;line-height:35px!important;text-decoration:none!important;text-transform:none!important}#mega-menu-wrap-primary .resources-menu ul.mega-sub-menu>li.mega-menu-item,#mega-menu-wrap-primary .company-menu ul.mega-sub-menu>li.mega-menu-item{padding:5px 15px!important;width:100%}#mega-menu-wrap-primary .company-menu h5,#mega-menu-wrap-primary .resources-menu h5{display:flex;align-items:center;font-size:14px!important;text-transform:uppercase!important}#mega-menu-wrap-primary .menu-widget-link .resources-menu a,#mega-menu-wrap-primary .menu-widget-link .company-menu a{color:#040404!important;font-size:20px}#mega-menu-wrap-primary li.resources-menu-link a.mega-menu-link .mega-description-group .mega-menu-title,#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.resources-menu-link>ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link,#mega-menu-wrap-primary li.company-menu-link a.mega-menu-link .mega-description-group .mega-menu-title,#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.company-menu-link>ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link{color:#49525b!important;cursor:pointer!important;text-transform:none!important;line-height:1.7!important;font-size:18px!important}#mega-menu-wrap-primary li.resources-menu-link a.mega-menu-link .mega-description-group .mega-menu-title:hover,#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.resources-menu-link>ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link:hover,#mega-menu-wrap-primary li.company-menu-link a.mega-menu-link .mega-description-group .mega-menu-title:hover,#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.company-menu-link>ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link:hover{text-decoration:underline!important;font-weight:700!important}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.resources-menu-link::before,#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.company-menu-link::before,#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.menu-supported::before{content:"";position:absolute;display:inline-block!important;background-color:#dfe4e8;width:1px;bottom:0;left:-10%;z-index:9999;top:0;height:100%}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.menu-supported::before{left:-20%}#mega-menu-wrap-primary #mega-menu-primary .menu-supported{max-width:20%!important}#mega-menu-wrap-primary #mega-menu-primary li.separator-menu-r{max-width:3%!important}#mega-menu-wrap-primary #mega-menu-primary li.separator-menu-c{max-width:3%!important}#mega-menu-wrap-primary #mega-menu-primary li.menu-roles-c{width:10%!important}#mega-menu-wrap-primary #mega-menu-primary li.menu-first-c{width:9%!important}#mega-menu-wrap-primary .resources-menu .mega-menu-description,#mega-menu-wrap-primary .company-menu .mega-menu-description{display:none!important}#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-item{margin:0!important;padding:0!important;font-family:"Pluto Sans Condensed";min-width:100px}#mega-menu-wrap-primary div[class*="icon-"]{position:relative!important;margin-bottom:15px}#mega-menu-wrap-primary div[class*="icon-"] span{padding-left:35px;text-transform:uppercase;font-weight:500;color:#637282}#mega-menu-wrap-primary .menu-widget-link a{color:#1b2733!important;font-size:20px;font-weight:500!important;font-family:Pluto Sans!important;line-height:1.2!important;padding-right:5px}#mega-menu-wrap-primary div[class*="icon-"]:before{content:"";background-repeat:no-repeat;background-size:cover;position:absolute;top:50%;transform:translateY(-50%);width:21px;height:16px}#mega-menu-wrap-primary .mega-sub-menu .icon-case-study:before{background-image:url(/media/menu-Icon-case-study.png);width:17px;height:21px}#mega-menu-wrap-primary .mega-sub-menu .icon-video:before{background-image:url(/media/menu-Icon-video.png)}#mega-menu-wrap-primary .mega-sub-menu .icon-ebook:before{background-image:url(/media/menu-Icon-ebook.png)}#mega-menu-wrap-primary .mega-sub-menu .icon-webinar:before{background-image:url(/media/menu-Icon-webinar.png)}#mega-menu-wrap-primary .mega-sub-menu .icon-event:before{background-image:url(/media/menu-Icon-Announcment.png);width:21px;height:23px}#mega-menu-wrap-primary .mega-sub-menu .icon-blog:before{background-image:url(/media/menu-Icon-Blog.png);height:21px}#mega-menu-wrap-primary .mega-sub-menu .icon-press-release:before{background-image:url(/media/menu-Icon-PressRelease.png);height:21px}#mega-menu-wrap-primary .mega-sub-menu .icon-podcast:before{background-image:url(/media/menu-Icon-Podcast.png);height:21px}#mega-menu-wrap-primary .mega-sub-menu .icon-white-paper:before{background-image:url(/media/menu-Icon-ebook.png)}#mega-menu-wrap-primary li.resources-menu #mega-menu-4504-0-4{padding-left:10px}#mega-menu-wrap-primary #mega-menu-primary .menu_widget{max-width:95%!important}.mega-menu-link span.mega-menu-description{display:none!important}@media screen and (max-width:1150px) and (min-width:1025px){#responsive-menu-pro-header{position:fixed;background-color:#fff;height:80px;color:#fff;display:block;font-size:14px}#responsive-menu-pro-header #responsive-menu-pro-header-bar-items-container{line-height:80px}}@media screen and (max-width:1250px) and (min-width:1150px){#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-item>a.mega-menu-link{padding:0 2px!important}nav ul#menu-top-menu{justify-content:center!important}}@media screen and (max-width:1510px) and (min-width:1441px){#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-item>a.mega-menu-link{padding:0 7px;font-size:15px}#mega-menu-14446-0-0,#mega-menu-14452-0-0{width:360px!important}}@media screen and (max-width:1610px) and (min-width:1511px){#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-item>a.mega-menu-link{padding:0 10px;font-size:15px}#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14452-0-4 ul.mega-sub-menu>li.mega-menu-item,#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14446-0-4 ul.mega-sub-menu>li.mega-menu-item{padding-left:0!important}}@media screen and (max-width:1710px) and (min-width:1611px){#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-item>a.mega-menu-link{padding:0 15px;font-size:16px}#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14452-0-4 ul.mega-sub-menu>li.mega-menu-item,#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14446-0-4 ul.mega-sub-menu>li.mega-menu-item{padding-left:0!important}}@media screen and (max-width:1810px) and (min-width:1711px){#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-item>a.mega-menu-link{padding:0 20px}#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14452-0-4 ul.mega-sub-menu>li.mega-menu-item,#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14446-0-4 ul.mega-sub-menu>li.mega-menu-item{padding-left:0!important}}@media screen and (max-width:1920px) and (min-width:1810px){#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14452-0-4 ul.mega-sub-menu>li.mega-menu-item,#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14446-0-4 ul.mega-sub-menu>li.mega-menu-item{padding-left:10px!important}}@media screen and (max-width:2400px) and (min-width:1921px){#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14452-0-4 ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link,#mega-menu-wrap-primary #mega-menu-primary #mega-menu-14446-0-4 ul.mega-sub-menu>li.mega-menu-item>a.mega-menu-link{padding-left:0!important}#mega-menu-wrap-primary #mega-menu-primary .menu_widget{max-width:93%!important}}@media screen and (max-width:1550px) and (min-width:1024px){#mega-menu-wrap-primary #mega-menu-primary>li.mega-menu-megamenu>ul.mega-sub-menu li.menu-supported::before{left:-5%}#mega-menu-wrap-primary #mega-menu-4504-0-0{width:15.0%!important}}@media screen and (max-width:1440px) and (min-width:1024px){ul#menu-top-menu .menu-item{margin-right:8px!important}ul#menu-top-menu .btn-menu{padding:6px 6px 6px}}​ @media screen and (max-width:1550px) and (min-width:1361px){#mega-menu-wrap-primary #mega-menu-4511-0-0{width:22%!important}#mega-menu-wrap-primary li.resources-menu #mega-menu-4504-0-4{padding-left:5px!important}}@media screen and (max-width:1360px) and (min-width:1281px){#mega-menu-wrap-primary #mega-menu-4511-0-0{width:22%!important}#mega-menu-wrap-primary li.resources-menu #mega-menu-4504-0-4,#mega-menu-wrap-primary li.company-menu #mega-menu-4511-0-4{padding-left:5px}}@media screen and (max-width:1280px) and (min-width:1181px){#mega-menu-wrap-primary #mega-menu-4511-0-0{width:23%!important}#mega-menu-wrap-primary li.resources-menu #mega-menu-4504-0-4{padding-left:5px}}@media screen and (max-width:1180px) and (min-width:1024px){#mega-menu-wrap-primary #mega-menu-4511-0-0{width:25%!important}#mega-menu-wrap-primary li.resources-menu #mega-menu-4504-0-4{padding-left:5px}}</style>
<script type="4e1c172490f29109ad76a1a3-text/javascript">
!function(o){var r=document.getElementsByTagName("script")[0];if("object"==typeof o.ClearbitForHubspot)return console.log("Clearbit For HubSpot included more than once"),!1;o.ClearbitForHubspot={},o.ClearbitForHubspot.forms=[],o.ClearbitForHubspot.addForm=function(r){var t=r[0];"function"==typeof o.ClearbitForHubspot.onFormReady?o.ClearbitForHubspot.onFormReady(t):o.ClearbitForHubspot.forms.push(t)};var t=document.createElement("script");t.async=!0,t.src="https://hubspot.clearbit.com/v1/forms/pk_894dcce6b09349a75e3c3f2db1d9c4e9/forms.js",r.parentNode.insertBefore(t,r)}(window);
</script>
</head>
<body class="sp-country-cn post-template-default single single-post postid-5927 single-format-standard ctcc-exclude-AF ctcc-exclude-AN ctcc-exclude-AS ctcc-exclude-EU ctcc-exclude-NA ctcc-exclude-OC ctcc-exclude-SA mega-menu-primary  wpb-js-composer js-comp-ver-6.1 vc_responsive responsive-menu-pro-slide-left">

<noscript><iframe
height="0" width="0" style="display:none;visibility:hidden" data-src="https://www.googletagmanager.com/ns.html?id=GTM-WBHPCG7" class="lazyload" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="></iframe></noscript>


<header id="header">
<nav class="navbar navbar-expand-md navbar-light bg-faded fixed-top" role="navigation">
<div class="d-flex col-3 order-0 p-0">
<a class="navbar-brand mr-1" href="https://www.instana.com"><img alt="header-logo" data-src="https://www.instana.com/media/INSTANA-logo.svg" class="img-fluid header-logo lazyload" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" /><noscript><img class="img-fluid header-logo" src="https://www.instana.com/media/INSTANA-logo.svg" alt="header-logo" /></noscript></a>
</div>
<div class="col-6 p-0">
<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-controls="bs-example-navbar-collapse-1" aria-expanded="false" aria-label="Toggle navigation">
<span class="navbar-toggler-icon"></span>
</button>
<div id="mega-menu-wrap-primary" class="mega-menu-wrap"><div class="mega-menu-toggle"><div class="mega-toggle-blocks-left"></div><div class="mega-toggle-blocks-center"></div><div class="mega-toggle-blocks-right"><div class='mega-toggle-block mega-menu-toggle-animated-block mega-toggle-block-0' id='mega-toggle-block-0'><button aria-label="Toggle Menu" class="mega-toggle-animated mega-toggle-animated-slider" type="button" aria-expanded="false">
<span class="mega-toggle-animated-box">
<span class="mega-toggle-animated-inner"></span>
</span>
</button></div></div></div><ul id="mega-menu-primary" class="mega-menu max-mega-menu mega-menu-horizontal mega-no-js" data-event="click" data-effect="fade_up" data-effect-speed="200" data-effect-mobile="disabled" data-effect-speed-mobile="0" data-panel-width="body" data-panel-inner-width=".wrapper" data-mobile-force-width="false" data-second-click="go" data-document-click="collapse" data-vertical-behaviour="standard" data-breakpoint="600" data-unbind="true" data-mobile-state="collapse_all" data-hover-intent-timeout="300" data-hover-intent-interval="100"><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-menu-megamenu mega-align-bottom-left mega-menu-grid mega-menu-item-14391' id='mega-menu-item-14391'><a class="mega-menu-link" aria-haspopup="true" aria-expanded="false" tabindex="0">Platform<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-row' id='mega-menu-14391-0'>
<ul class="mega-sub-menu">
<li class='mega-menu-column mega-menu-columns-1-of-12' id='mega-menu-14391-0-0'></li><li class='mega-menu-column mega-menu-enterprise mega-menu-columns-3-of-12 menu-enterprise' id='mega-menu-14391-0-1'>
<ul class="mega-sub-menu">
<li class='mega-sp-navigation-dropdown-panel-column-1 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-disable-link mega-menu-item-14392 sp-navigation-dropdown-panel-column-1 sp-navigation-item-block' id='mega-menu-item-14392'><a class="mega-menu-link" tabindex="0">Enterprise Observability<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14393' id='mega-menu-item-14393'><a class="mega-menu-link" href="/enterprise-observability-platform">Enterprise Observability Platform</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14394' id='mega-menu-item-14394'><a class="mega-menu-link" href="/automated-application-performance-monitoring/">Application Performance Monitoring</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14395' id='mega-menu-item-14395'><a class="mega-menu-link" href="/website-end-user-monitoring">Web Site Monitoring</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14396' id='mega-menu-item-14396'><a class="mega-menu-link" href="/cloud-and-infrastructure-monitoring">Cloud & Infrastructure Monitoring</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14397' id='mega-menu-item-14397'><a class="mega-menu-link" href="/microservices-apm">Microservices Monitoring</a></li> </ul>
</li> </ul>
</li><li class='mega-menu-column mega-menu-supported mega-menu-columns-3-of-12 menu-supported' id='mega-menu-14391-0-2'>
<ul class="mega-sub-menu">
<li class='mega-drop-down-company mega-sp-navigation-dropdown-panel-column-1 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-disable-link mega-menu-item-14398 drop-down-company sp-navigation-dropdown-panel-column-1 sp-navigation-item-block' id='mega-menu-item-14398'><a class="mega-menu-link" tabindex="0">Supported Technologies<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14399' id='mega-menu-item-14399'><a class="mega-menu-link" href="/supported-technologies/">All Technologies</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14400' id='mega-menu-item-14400'><a class="mega-menu-link" href="/blog/supported-technology-type/tracing-supported-languages-frameworks/application-monitoring/">Languages</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14401' id='mega-menu-item-14401'><a class="mega-menu-link" href="/blog/supported-technology-type/cloud-operations/">Cloud Platforms</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14402' id='mega-menu-item-14402'><a class="mega-menu-link" href="/supported-technologies/compute-engine-monitoring/">Google Cloud Platform</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14403' id='mega-menu-item-14403'><a class="mega-menu-link" href="/supported-technologies/aws-ec2-monitoring/">Amazon AWS</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14404' id='mega-menu-item-14404'><a class="mega-menu-link" href="/supported-technologies/microsoft-azure-monitoring/">Microsoft Azure</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14405' id='mega-menu-item-14405'><a class="mega-menu-link" href="/supported-technologies/ibm-bluemix-monitoring/">IBM Cloud / Red Hat Marketplace</a></li> </ul>
</li> </ul>
</li><li class='mega-menu-column mega-kubernetes-dist mega-menu-columns-3-of-12 kubernetes-dist' id='mega-menu-14391-0-3'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-menu-item-14406' id='mega-menu-item-14406'><a class="mega-menu-link" href="#">Kubernetes Distributions<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14407' id='mega-menu-item-14407'><a class="mega-menu-link" href="/supported-technologies/google-gke-monitoring/">Google GKE</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14408' id='mega-menu-item-14408'><a class="mega-menu-link" href="/supported-technologies/openshift-monitoring/">Red Hat OpenShift</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14409' id='mega-menu-item-14409'><a class="mega-menu-link" href="/supported-technologies/pivotal-container-service-pks-monitoring/">VMware Tanzu</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14410' id='mega-menu-item-14410'><a class="mega-menu-link" href="/supported-technologies/amazon-eks-monitoring/">AWS EKS</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14411' id='mega-menu-item-14411'><a class="mega-menu-link" href="/supported-technologies/azure-aks-monitoring/">Azure AKS</a></li> </ul>
</li> </ul>
</li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14391-0-4'></li> </ul>
</li></ul>
</li><li class='mega-solutions-menu-item mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-menu-megamenu mega-align-bottom-left mega-menu-grid mega-menu-item-14412 solutions-menu-item' id='mega-menu-item-14412'><a class="mega-menu-link" aria-haspopup="true" aria-expanded="false" tabindex="0">Solutions<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-row mega-mega-menu-row mega-menu-row' id='mega-menu-14412-0'>
<ul class="mega-sub-menu">
<li class='mega-menu-column mega-.menu-first-c mega-menu-columns-2-of-12 .menu-first-c' id='mega-menu-14412-0-0'></li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14412-0-1'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-disable-link mega-menu-item-14413' id='mega-menu-item-14413'><a class="mega-menu-link" tabindex="0">Observability and Monitoring<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-post_type mega-menu-item-object-page mega-has-description mega-menu-item-14414' id='mega-menu-item-14414'><a class="mega-menu-link" href="https://www.instana.com/apm-for-microservices/"><span class="mega-description-group"><span class="mega-menu-title">Microservices Observability</span><span class="mega-menu-description"> </span></span></a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14415' id='mega-menu-item-14415'><a class="mega-menu-link" href="/apm-for-containers/">Container Observability</a></li><li class='mega-menu-item mega-menu-item-type-post_type mega-menu-item-object-page mega-has-description mega-menu-item-14416' id='mega-menu-item-14416'><a class="mega-menu-link" href="https://www.instana.com/apm-for-service-oriented-architectures/"><span class="mega-description-group"><span class="mega-menu-title">Monitoring SOA</span><span class="mega-menu-description"> </span></span></a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14417' id='mega-menu-item-14417'><a class="mega-menu-link" href="/observability-for-hybrid-cloud-applications/">Monitoring Hybrid Cloud</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14418' id='mega-menu-item-14418'><a class="mega-menu-link" href="#">Monitoring Multi-Cloud</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14419' id='mega-menu-item-14419'><a class="mega-menu-link" href="/automatic-kubernetes-monitoring/">Kubernetes Monitoring</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14420' id='mega-menu-item-14420'><a class="mega-menu-link" href="/automatic-root-cause-analysis/">Automatic Root Cause Analysis</a></li> </ul>
</li> </ul>
</li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14412-0-2'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-disable-link mega-menu-item-14421' id='mega-menu-item-14421'><a class="mega-menu-link" tabindex="0">Open Source Standards<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14422' id='mega-menu-item-14422'><a class="mega-menu-link" href="/supported-technologies/jaeger-apm-integration/">Jaeger</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14423' id='mega-menu-item-14423'><a class="mega-menu-link" href="/supported-technologies/opentracing/">OpenTracing</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14424' id='mega-menu-item-14424'><a class="mega-menu-link" href="/docs/ecosystem/prometheus/#main">Prometheus</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14425' id='mega-menu-item-14425'><a class="mega-menu-link" href="/docs/ecosystem/opentelemetry/#main">Open Telemetry</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14426' id='mega-menu-item-14426'><a class="mega-menu-link" href="/supported-technologies/zipkin-apm-integration/">Zipkin</a></li> </ul>
</li> </ul>
</li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14412-0-3'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-disable-link mega-menu-item-14427' id='mega-menu-item-14427'><a class="mega-menu-link" tabindex="0">Kubernetes Distributions<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14428' id='mega-menu-item-14428'><a class="mega-menu-link" href="/supported-technologies/google-gke-monitoring/">Google GKE</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14429' id='mega-menu-item-14429'><a class="mega-menu-link" href="/supported-technologies/openshift-monitoring/">Red Hat OpenShift</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14430' id='mega-menu-item-14430'><a class="mega-menu-link" href="/supported-technologies/pivotal-container-service-pks-monitoring/">VMware Tanzu</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14431' id='mega-menu-item-14431'><a class="mega-menu-link" href="/supported-technologies/amazon-eks-monitoring/">AWS EKS</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14432' id='mega-menu-item-14432'><a class="mega-menu-link" href="/supported-technologies/azure-aks-monitoring/">Azure AKS</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14433' id='mega-menu-item-14433'><a class="mega-menu-link" href="/automatic-kubernetes-monitoring/">Kubernetes Monitoring</a></li> </ul>
</li> </ul>
</li><li class='mega-menu-column mega-menu-roles-c mega-menu-columns-1-of-12 menu-roles-c' id='mega-menu-14412-0-4'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-disable-link mega-menu-item-14434' id='mega-menu-item-14434'><a class="mega-menu-link" tabindex="0">Roles<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14435' id='mega-menu-item-14435'><a class="mega-menu-link" href="/observability-and-application-monitoring-for-site-reliability-engineers-sres/">SRE</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14436' id='mega-menu-item-14436'><a class="mega-menu-link" href="/observability-and-application-monitoring-for-devops/">DevOps</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14437' id='mega-menu-item-14437'><a class="mega-menu-link" href="/observability-and-application-monitoring-for-developers/">Developers</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14438' id='mega-menu-item-14438'><a class="mega-menu-link" href="/observability-and-application-monitoring-for-it-managers-and-executives/">Executives</a></li> </ul>
</li> </ul>
</li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14412-0-5'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-disable-link mega-menu-item-14439' id='mega-menu-item-14439'><a class="mega-menu-link" tabindex="0">Cloud Platforms<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14440' id='mega-menu-item-14440'><a class="mega-menu-link" href="/gcp-observability-and-application-monitoring/">Google Cloud Platforms (GCP)</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14441' id='mega-menu-item-14441'><a class="mega-menu-link" href="/supported-technologies/microsoft-azure-monitoring/">Microsoft Azure</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14442' id='mega-menu-item-14442'><a class="mega-menu-link" href="/aws-observability-and-application-monitoring/">Amazon AWS</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14443' id='mega-menu-item-14443'><a class="mega-menu-link" href="/supported-technologies/ibm-bluemix-monitoring/">IBM Cloud</a></li> </ul>
</li> </ul>
</li> </ul>
</li></ul>
</li><li class='mega-menu-item mega-menu-item-type-post_type mega-menu-item-object-page mega-align-bottom-left mega-menu-flyout mega-menu-item-14444' id='mega-menu-item-14444'><a class="mega-menu-link" href="https://www.instana.com/how-instana-dynamic-apm-works/" tabindex="0">Why Instana?</a></li><li class='mega-menu-item mega-menu-item-type-post_type mega-menu-item-object-page mega-align-bottom-left mega-menu-flyout mega-has-description mega-menu-item-14445' id='mega-menu-item-14445'><a class="mega-menu-link" href="https://www.instana.com/pricing/" tabindex="0"><span class="mega-description-group"><span class="mega-menu-title">Pricing</span><span class="mega-menu-description"> </span></span></a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-menu-megamenu mega-align-bottom-left mega-menu-grid mega-menu-item-14446' id='mega-menu-item-14446'><a class="mega-menu-link" aria-haspopup="true" aria-expanded="false" tabindex="0">Resources<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-row mega-resources-menu resources-menu' id='mega-menu-14446-0'>
<ul class="mega-sub-menu">
<li class='mega-menu-column mega-menu-columns-3-of-12' id='mega-menu-14446-0-0'></li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14446-0-1'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-widget menu_widget mega-menu-item-menu_widget-6' id='mega-menu-item-menu_widget-6'><div class="row"><div class="col-12 icon-ebook"><span>eBook</span></div></div><div class="row"><div class="col-12 menu-widget-link"><a href="/library/ebook-foundations-of-enterprise-observability/" class="button">Enterprise Observability: Real-world needs for complex applications</a></div></div></li> </ul>
</li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14446-0-2'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-widget menu_widget mega-menu-item-menu_widget-7' id='mega-menu-item-menu_widget-7'><div class="row"><div class="col-12 icon-webinar"><span>Webinar</span></div></div><div class="row"><div class="col-12 menu-widget-link"><a href="/webinars/distibuted-tracing-logs/" class="button">Distributed Tracing and Logs: How Decisiv Troubleshoots Issues</a></div></div></li> </ul>
</li><li class='mega-menu-column mega-separator-menu-r mega-menu-columns-1-of-12 separator-menu-r' id='mega-menu-14446-0-3'></li><li class='mega-menu-column mega-resources-menu-link mega-menu-columns-3-of-12 resources-menu-link' id='mega-menu-14446-0-4'>
<ul class="mega-sub-menu">
<li class='mega-drop-down-company mega-sp-navigation-dropdown-panel-column-2 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14449 drop-down-company sp-navigation-dropdown-panel-column-2 sp-navigation-item-block' id='mega-menu-item-14449'><a class="mega-menu-link" href="/resources/">Whitepapers and eBooks</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14618' id='mega-menu-item-14618'><a class="mega-menu-link" href="/customers/">Customer Success Stories</a></li><li class='mega-drop-down-company mega-sp-navigation-dropdown-panel-column-1 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14448 drop-down-company sp-navigation-dropdown-panel-column-1 sp-navigation-item-block' id='mega-menu-item-14448'><a class="mega-menu-link" href="/webinars/">Webinars</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14619' id='mega-menu-item-14619'><a class="mega-menu-link" href="/training-resources/">Video Guides</a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14471' id='mega-menu-item-14471'><a class="mega-menu-link" href="/events/">Events</a></li><li class='mega-drop-down-company mega-sp-navigation-dropdown-panel-column-2 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14450 drop-down-company sp-navigation-dropdown-panel-column-2 sp-navigation-item-block' id='mega-menu-item-14450'><a class="mega-menu-link" href="/blog/category/engineering/">Engineering Blog</a></li><li class='mega-drop-down-company mega-sp-navigation-dropdown-panel-column-2 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14451 drop-down-company sp-navigation-dropdown-panel-column-2 sp-navigation-item-block' id='mega-menu-item-14451'><a target="_blank" class="mega-menu-link" rel="noopener" href="https://docs.instana.com/?__hstc=1833966.97fec7c5f19d190df82ea098ec630fbf.1541082789840.1544080364506.1544165984612.26&#038;__hssc=1833966.6.1549354890660&#038;__hsfp=2988742834">Documentation</a></li> </ul>
</li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14446-0-5'></li> </ul>
</li></ul>
</li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-has-children mega-menu-megamenu mega-align-bottom-left mega-menu-grid mega-menu-item-14452' id='mega-menu-item-14452'><a class="mega-menu-link" aria-haspopup="true" aria-expanded="false" tabindex="0">Company<span class="mega-indicator"></span></a>
<ul class="mega-sub-menu">
<li class='mega-menu-row mega-company-menu company-menu' id='mega-menu-14452-0'>
<ul class="mega-sub-menu">
<li class='mega-menu-column mega-menu-columns-3-of-12' id='mega-menu-14452-0-0'></li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14452-0-1'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-widget menu_widget mega-menu-item-menu_widget-8' id='mega-menu-item-menu_widget-8'><div class="row"><div class="col-12 icon-case-study"><span>Case Study</span></div></div><div class="row"><div class="col-12 menu-widget-link"><a href="/customers/macmillan-learning-achieves-10x-application-performance/" class="button">Macmillan Learning Achieves 10x Application Performance</a></div></div></li> </ul>
</li><li class='mega-menu-column mega-menu-columns-2-of-12' id='mega-menu-14452-0-2'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-widget menu_widget mega-menu-item-menu_widget-9' id='mega-menu-item-menu_widget-9'><div class="row"><div class="col-12 icon-white-paper"><span>White Paper</span></div></div><div class="row"><div class="col-12 menu-widget-link"><a href="/library/whitepaper-extending-apm-to-observability/" class="button">From APMExperts: APM and Observability Working Together</a></div></div></li> </ul>
</li><li class='mega-menu-column mega-separator-menu-c mega-menu-columns-1-of-12 separator-menu-c' id='mega-menu-14452-0-3'></li><li class='mega-menu-column mega-company-menu-link mega-menu-columns-3-of-12 company-menu-link' id='mega-menu-14452-0-4'>
<ul class="mega-sub-menu">
<li class='mega-menu-item mega-menu-item-type-post_type mega-menu-item-object-page mega-has-description mega-menu-item-14453' id='mega-menu-item-14453'><a class="mega-menu-link" href="https://www.instana.com/company/"><span class="mega-description-group"><span class="mega-menu-title">Background and Vision</span><span class="mega-menu-description"> </span></span></a></li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14469' id='mega-menu-item-14469'><a class="mega-menu-link" href="/partners">Partners</a></li><li class='mega-drop-down-company mega-sp-navigation-dropdown-panel-column-1 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14455 drop-down-company sp-navigation-dropdown-panel-column-1 sp-navigation-item-block' id='mega-menu-item-14455'><a class="mega-menu-link" href="/customers/">Customers</a></li><li class='mega-drop-down-company mega-sp-navigation-dropdown-panel-column-1 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14456 drop-down-company sp-navigation-dropdown-panel-column-1 sp-navigation-item-block' id='mega-menu-item-14456'><a class="mega-menu-link" href="/announcements/">Announcements</a></li><li class='mega-drop-down-company mega-sp-navigation-dropdown-panel-column-2 mega-sp-navigation-item-block mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-menu-item-14457 drop-down-company sp-navigation-dropdown-panel-column-2 sp-navigation-item-block' id='mega-menu-item-14457'><a class="mega-menu-link" href="/newsroom/">Newsroom</a></li><li class='mega-menu-item mega-menu-item-type-post_type mega-menu-item-object-page mega-has-description mega-menu-item-14458' id='mega-menu-item-14458'><a class="mega-menu-link" href="https://www.instana.com/careers/"><span class="mega-description-group"><span class="mega-menu-title">Careers</span><span class="mega-menu-description"> </span></span></a></li><li class='mega-menu-item mega-menu-item-type-post_type mega-menu-item-object-page mega-has-description mega-menu-item-14459' id='mega-menu-item-14459'><a class="mega-menu-link" href="https://www.instana.com/contact-us/"><span class="mega-description-group"><span class="mega-menu-title">Contact Us</span><span class="mega-menu-description"> </span></span></a></li> </ul>
</li><li class='mega-menu-column mega-menu-columns-1-of-12' id='mega-menu-14452-0-5'></li> </ul>
</li></ul>
</li><li class='mega-menu-item mega-menu-item-type-custom mega-menu-item-object-custom mega-align-bottom-left mega-menu-flyout mega-menu-item-14844' id='mega-menu-item-14844'><a class="mega-menu-link" href="/blog" tabindex="0">Blog</a></li></ul></div>
</div>
<span class="navbar-text col-3 text-right order-1 order-md-last d-flex justify-content-end flex-column p-0">
<div class="row">
<div class="right-menu col-12"><ul id="menu-top-menu" class="right-menu-inner"><li id="menu-item-9160" class="btn btn-menu button-menu menu-item menu-item-type-custom menu-item-object-custom menu-item-9160"><a href="/trial/">Free Trial</a></li>
<li id="menu-item-4524" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-4524"><a target="_blank" rel="noopener" href="https://www.instana.com/docs/">Docs</a></li>
<li id="menu-item-4525" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-4525"><a target="_blank" rel="noopener" href="https://instana.io">Sign In</a></li>
<li id="menu-item-12017" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-12017"><a href="#"><a href='javascript:void(0);'><i class="fa fa-search top-search" aria-hidden="true"></i></a></a></li>
</ul></div> <div class="menu-search-box">
<form class="search-form" role="search" method="get" action="https://www.instana.com">
<input class="search-form-input form-control" type="text" value="" name="s" id="s" placeholder="Search...">
</form>
</div>
<script type="4e1c172490f29109ad76a1a3-text/javascript">
                    /*Top menu search*/
                    jQuery(document).ready(function($){
                        $(".top-search").click(function() {
                           $(".menu-search-box").toggle("slow");
                           $(".form-control").focus();
                         });
                    });
                    /*Hide menu on click anywhere else*/
                    jQuery(document).mouseup(function (e) {
                         if ($(e.target).closest(".menu-search-box").length === 0) {
                            $(".menu-search-box").hide("slow");
                         }
                    });
                    /*Shadow on menu*/
                    jQuery(window).scroll(function() {
                        var scroll = $(window).scrollTop();
                        if (scroll <= 50) {
                            $("body ").removeClass("scrolled");
                        } else {
                            $("body").addClass("scrolled");
                        }
                    });
            </script>
</span>
</div>
</nav>
</header>


<div id="main">
<div class="blog-header">
<div class="">
<div class="wrapper px-4 pt-4">

<div class="row">
<div class="col-lg-8 col-md-12 col-sm-12">
<div class="post-header-title"><h1>
Writing a Kubernetes Operator in Java: Part 3</h1>
</div>
<div class="avatar-blog-content-top pb-4">
<div class="col-lg-12 col-md-12 col-xs-12 nopadding">
<div class="col-lg-12 col-md-12 col-xs-12 nopadding">
<div class="flex-box-blog">
<div class="author-name">By <a href="https://www.instana.com/blog/author/fabians/" title="Fabian Staeber" target="_blank">Fabian Staeber</a>
</div>
<div class="date-category category-line">
 <div class="date-single"><p><span>July 2, 2019</span></p></div>
</div>
<div class="date-category">
<div class="category-single"><a href="https://www.instana.com/blog/category/engineering/" rel="category tag">Engineering</a></div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<div class="avatar-blog-content-top">
<div class="col-lg-8 col-md-12 col-xs-12 nopadding">
<div class="col-lg-12 col-md-12 col-xs-12 nopadding">
<div class="col-lg-12 nopadding">
<div class="blog-img-container">
<img alt="Post" data-src="https://www.instana.com/media/Default_Post_Image.png" class="img-fluid lazyload" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="><noscript><img class="img-fluid" src="https://www.instana.com/media/Default_Post_Image.png" alt="Post"></noscript>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
</div>
<div class="wrapper px-4 pt-3 pb-4">
<div class="row blog-post-body-outer">
<div class="col-lg-8 col-md-12 col-sm-12 blog-post-body sp-lightbox-auto">
<h2>Part 3: Writing a Kubernetes Operator in Java</h2>
<p>In the <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-2">previous post</a> of this series, we created an example <a href="https://quarkus.io">Quarkus</a> project using the <a href="https://quarkus.io/extensions/">Kubernetes client extension</a>. The example retrieved a list of Pods and logged the list to the console.</p>
<p>In this post, we will extend this example with functionality that you typically find in operators.</p>
<h2>Functionality of the Example Operator</h2>
<p>At Instana, we recently published the first alpha version of our <a href="https://github.com/instana/instana-agent-operator">Instana Agent Operator</a>. The main task of the operator is to create a <code>DaemonSet</code> such that one Instana agent is running on each Kubernetes node.</p>
<p>However, there are special roles that need to be present only once in the cluster. The operator takes care that exactly one Pod from the daemon set gets assigned the special role.</p>
<p>In this Blog post, we will implement a stripped-down version of this functionality. We create a custom resource defining some special roles, and we will implement an operator creating a daemon set when that resource is created.</p>
<h2>Custom Resource Model</h2>
<p>Our example resource looks like this:</p>
<pre><code class="language-yaml">apiVersion: instana.com/v1alpha1
kind: Example
metadata:
  name: example
spec:
  specialRoles:
  - A
  - B
  - C
</code></pre>
<p>Reading the custom resource is simple, because the Kubernetes client will automatically deserialize the resource to a Java object. All we need to do is to define a model class for the <code>spec</code> using <a href="https://github.com/FasterXML/jackson-annotations">Jackson</a> annotations, and some boilerplate classes.</p>
<p>Our model class models the <code>specialRoles</code> as a <code>Set</code> of <code>String</code>:</p>
<pre><code class="language-java">package com.instana.operator.example.cr;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import io.quarkus.runtime.annotations.RegisterForReflection;

import java.util.Arrays;
import java.util.Set;

@JsonDeserialize
@RegisterForReflection
public class ExampleResourceSpec {

  @JsonProperty("specialRoles")
  private Set&lt;String&gt; specialRoles;

  public Set&lt;String&gt; getSpecialRoles() {
    return specialRoles;
  }

  @Override
  public String toString() {
    return "specialRoles=" + Arrays.toString(specialRoles.toArray(new String[] {}));
  }
}
</code></pre>
<p>Apart from the standard Jackson annotations, this class is annotated with <code>@RegisterForReflection</code>. This is needed when building native executables. It tells the compiler that instances of this class are created at runtime and the compiler must not optimize away the constructor.</p>
<p>Next, there are three classes of boiler plate code needed to use the custom resource in the fabric8 Kubernetes client:</p>
<p>Class ExampleResource:</p>
<pre><code class="language-java">package com.instana.operator.example.cr;

import io.fabric8.kubernetes.client.CustomResource;

public class ExampleResource extends CustomResource {

  private ExampleResourceSpec spec;

  public ExampleResourceSpec getSpec() {
    return spec;
  }

  public void setSpec(ExampleResourceSpec spec) {
    this.spec = spec;
  }

  @Override
  public String toString() {
    String name = getMetadata() != null ? getMetadata().getName() : "unknown";
    String version = getMetadata() != null ? getMetadata().getResourceVersion() : "unknown";
    return "name=" + name + " version=" + version + " value=" + spec;
  }
}
</code></pre>
<p>Class ExampleResourceList:</p>
<pre><code class="language-java">package com.instana.operator.example.cr;

import io.fabric8.kubernetes.client.CustomResourceList;

public class ExampleResourceList extends CustomResourceList&lt;ExampleResource&gt; {
  // empty
}
</code></pre>
<p>Class ExampleResourceDoneable:</p>
<pre><code class="language-java">package com.instana.operator.example.cr;

import io.fabric8.kubernetes.api.builder.Function;
import io.fabric8.kubernetes.client.CustomResourceDoneable;

public class ExampleResourceDoneable extends CustomResourceDoneable&lt;ExampleResource&gt; {

  public ExampleResourceDoneable(ExampleResource resource, Function&lt;ExampleResource, ExampleResource&gt; function) {
    super(resource, function);
  }
}
</code></pre>
<h2>Custom Resource Client</h2>
<p>Now that we have a model for our custom resource, we need a client to list and watch our resources. With the Kubernetes client API, we will have different clients for accessing built-in Kubernetes resources and custom resources:</p>
<ul>
<li>The <code>KubernetesClient</code> is used to access built-in resources. We already created a producer method for this client in our <code>ClientProvider</code> in the <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-2">previous post</a>.</li>
<li>For accessing the custom resource, we need to create a custom resource client. In order to do that, the Kubernetes client API requires us to load the <em>Custom Resource Definition</em> (CRD) from the API server, and create the custom resource client from the CRD. The custom resource client has the rather awkward type <code>NonNamespaceOperation</code> with a long list of generics parameters.</li>
</ul>
<p>We add a producer method for the custom resource client to our existing <code>ClientProvider</code>, so that we can <code>@Inject</code> the custom resource client where needed:</p>
<pre><code class="language-java">@Produces
@Singleton
NonNamespaceOperation&lt;ExampleResource, ExampleResourceList, ExampleResourceDoneable, Resource&lt;ExampleResource, ExampleResourceDoneable&gt;&gt; makeCustomResourceClient(KubernetesClient defaultClient, @Named("namespace") String namespace) {

  KubernetesDeserializer.registerCustomKind("instana.com/v1alpha1", "Example", ExampleResource.class);

  CustomResourceDefinition crd = defaultClient
      .customResourceDefinitions()
      .list()
      .getItems()
      .stream()
      .filter(d -&gt; "examples.instana.com".equals(d.getMetadata().getName()))
      .findAny()
      .orElseThrow(
          () -&gt; new RuntimeException("Deployment error: Custom resource definition examples.instana.com not found."));

  return defaultClient
      .customResources(crd, ExampleResource.class, ExampleResourceList.class, ExampleResourceDoneable.class)
      .inNamespace(namespace);
}
</code></pre>
<h2>Resource Cache</h2>
<p>At the core of a Kubernetes operator is a resource cache: For all watched resources, we want to keep a local cache with the resource state. This cache should be eventually consistent with the resource state on the API server. We model our cache as a <code>Map</code>&lt;<code>String, ExampleResource</code>&gt;, mapping the resources&#8217; uid to the current resource state from the cluster.</p>
<p>In order to maintain this cache, we need a <em>list-then-watch</em> operation: When starting up, we initialize the cache with the current state of the resources, then we watch for changes and update the cache accordingly.</p>
<p>Kubernetes provides a <em>resource version</em> for each resource, which is an integer increasing with each change. If we receive an event, we can use the resource version to learn if this is a new event, or if it&#8217;s outdated. Unfortunately the resource version is modeled as a String in the Kubernetes client, so we need to convert this to an integer.</p>
<p>As a hook for our business logic, the <code>listThenWatch()</code> method takes a callback as an argument. This callback is called with a pair of <code>(Action, UID)</code>, where the action is an enum with values <code>ADDED</code>, <code>MODIFIED</code>, or <code>DELETED</code>.</p>
<pre><code class="language-java">package com.instana.operator.example;

import com.instana.operator.example.cr.ExampleResource;
import com.instana.operator.example.cr.ExampleResourceDoneable;
import com.instana.operator.example.cr.ExampleResourceList;
import io.fabric8.kubernetes.client.KubernetesClientException;
import io.fabric8.kubernetes.client.Watcher;
import io.fabric8.kubernetes.client.dsl.NonNamespaceOperation;
import io.fabric8.kubernetes.client.dsl.Resource;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executor;
import java.util.concurrent.Executors;
import java.util.function.BiConsumer;

@ApplicationScoped
public class ExampleResourceCache {

  private final Map&lt;String, ExampleResource&gt; cache = new ConcurrentHashMap&lt;&gt;();

  @Inject
  private NonNamespaceOperation&lt;ExampleResource, ExampleResourceList, ExampleResourceDoneable, Resource&lt;ExampleResource, ExampleResourceDoneable&gt;&gt; crClient;

  private Executor executor = Executors.newSingleThreadExecutor();

  public ExampleResource get(String uid) {
    return cache.get(uid);
  }

  public void listThenWatch(BiConsumer&lt;Watcher.Action, String&gt; callback) {

    try {

      // list

      crClient
          .list()
          .getItems()
          .forEach(resource -&gt; {
                cache.put(resource.getMetadata().getUid(), resource);
                String uid = resource.getMetadata().getUid();
                executor.execute(() -&gt; callback.accept(Watcher.Action.ADDED, uid));
              }
          );

      // watch

      crClient.watch(new Watcher&lt;ExampleResource&gt;() {
        @Override
        public void eventReceived(Action action, ExampleResource resource) {
          try {
            String uid = resource.getMetadata().getUid();
            if (cache.containsKey(uid)) {
              int knownResourceVersion = Integer.parseInt(cache.get(uid).getMetadata().getResourceVersion());
              int receivedResourceVersion = Integer.parseInt(resource.getMetadata().getResourceVersion());
              if (knownResourceVersion &gt; receivedResourceVersion) {
                return;
              }
            }
            System.out.println("received " + action + " for resource " + resource);
            if (action == Action.ADDED || action == Action.MODIFIED) {
              cache.put(uid, resource);
            } else if (action == Action.DELETED) {
              cache.remove(uid);
            } else {
              System.err.println("Received unexpected " + action + " event for " + resource);
              System.exit(-1);
            }
            executor.execute(() -&gt; callback.accept(action, uid));
          } catch (Exception e) {
            e.printStackTrace();
            System.exit(-1);
          }
        }

        @Override
        public void onClose(KubernetesClientException cause) {
          cause.printStackTrace();
          System.exit(-1);
        }
      });
    } catch (Exception e) {
      e.printStackTrace();
      System.exit(-1);
    }
  }
}
</code></pre>
<p>A few notes on the code above:</p>
<ul>
<li>For each resource that we find in the initial <em>list</em> operation, we generate an artificial <code>ADDED</code> event so that the business logic knows there is a new resource.</li>
<li>In the <em>watch</em> part, we check if the received resource version is higher that our last known resource version, and if so we update the cache and generate an event.</li>
<li>The <code>eventReceived()</code> callback in the <em>watch</em> part may be executed in a different thread. Therefore, it is important to handle exceptions there, as they will not be propagated to the main thread.</li>
<li>We don&#8217;t want to block the Kubernetes client&#8217;s event handler thread. We create a single thread executor and schedule our callbacks there. As an additional advantage this implementation ensures that the callback is always called in the same thread, so the callback does not need to be thread safe.</li>
<li>It is a good idea to handle errors (like networking errors) with <code>System.exit(-1)</code>. This makes the operator Pod terminate and Kubernetes will restart it. If the error is permanent, the Pod will enter a crash backoff loop in Kubernetes.</li>
</ul>
<h2>Business Logic: Creating Daemon Sets</h2>
<p>Now that we have our resource cache, we hook in our business logic that will create a <code>DaemonSet</code> whenever a new custom resource is added.</p>
<pre><code class="language-java">package com.instana.operator.example;

import com.instana.operator.example.cr.ExampleResource;
import io.fabric8.kubernetes.api.model.apps.DaemonSet;
import io.fabric8.kubernetes.client.KubernetesClient;
import io.fabric8.kubernetes.client.Watcher;
import io.quarkus.runtime.StartupEvent;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.event.Observes;
import javax.inject.Inject;
import java.util.function.Predicate;

@ApplicationScoped
public class DaemonSetInstaller {

  @Inject
  private KubernetesClient client;

  @Inject
  private ExampleResourceCache cache;

  void onStartup(@Observes StartupEvent _ev) {
    new Thread(this::runWatch).start();
  }

  private void runWatch() {
    cache.listThenWatch(this::handleEvent);
  }

  private void handleEvent(Watcher.Action action, String uid) {
    try {
      ExampleResource resource = cache.get(uid);
      if (resource == null) {
        return;
      }

      Predicate&lt;DaemonSet&gt; ownerRefMatches = daemonSet -&gt; daemonSet.getMetadata().getOwnerReferences().stream()
          .anyMatch(ownerReference -&gt; ownerReference.getUid().equals(uid));

      if (client
          .apps()
          .daemonSets()
          .list()
          .getItems()
          .stream()
          .noneMatch(ownerRefMatches)) {

        client
            .apps()
            .daemonSets()
            .create(newDaemonSet(resource));
      }
    } catch (Exception e) {
      e.printStackTrace();
      System.exit(-1);
    }
  }

  private DaemonSet newDaemonSet(ExampleResource resource) {
    DaemonSet daemonSet = client.apps().daemonSets()
        .load(getClass().getResourceAsStream("/daemonset.yaml")).get();
    daemonSet.getMetadata().getOwnerReferences().get(0).setUid(resource.getMetadata().getUid());
    daemonSet.getMetadata().getOwnerReferences().get(0).setName(resource.getMetadata().getName());
    return daemonSet;
  }
}
</code></pre>
<p>Some notes on this code:</p>
<ul>
<li>We start watching custom resources on application startup when we receive the CDI <code>StartupEvent</code>, but we immediately fork off a new thread in order not to block the CDI event handler thread.</li>
<li>The <code>handleEvent()</code> callback is straightforward: It takes the custom resource as an owner reference, checks if a daemon set with that owner reference already exists, and creates a new one if it doesn&#8217;t. Owner references were covered in the <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-1">first post</a> of this series.</li>
</ul>
<p>The daemon set is defined in <code>daemonset.yaml</code> which is loaded from <code>src/main/resources/daemonset.yaml</code>:</p>
<pre><code class="language-yaml">apiVersion: apps/v1
kind: DaemonSet
metadata:
  generateName: example-
  namespace: default
  ownerReferences:
    - apiVersion: apps/v1
      kind: Example
      name: placeholder
      uid: placeholder
spec:
  selector:
    matchLabels:
      app: kuard
  template:
    metadata:
      labels:
        app: kuard
    spec:
      containers:
        - image: gcr.io/kuar-demo/kuard-amd64:blue
          imagePullPolicy: IfNotPresent
          name: kuard
</code></pre>
<p>In order to have <code>Quarkus</code> include the <code>daemonset.yaml</code> file in the native build, we need to add the following parameter to the <code>quarkus-maven-plugin</code> configuration in the <code>native</code> profile in <code>pom.xml</code>:</p>
<pre><code class="language-xml">&lt;additionalBuildArgs&gt;-H:IncludeResources=daemonset.yaml&lt;/additionalBuildArgs&gt;
</code></pre>
<h2>Build and run</h2>
<p>Create the Docker image with the commands from the <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-2">previous blog post</a>:</p>
<pre><code class="language-bash">./mvnw package -Pnative -DskipTests -Dnative-image.docker-build=true
docker build -f src/main/docker/Dockerfile.native -t quarkus-quickstart/getting-started .
</code></pre>
<p>Before deploying the operator, we need to create the custom resource definition, because the operator reads the custom resource definition on startup in <code>ClientProvider.makeCustomResourceClient()</code>.</p>
<p>Create a file <code>operator-example.crd.yaml</code> with the following content:</p>
<pre><code class="language-yaml">apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: examples.instana.com
spec:
  group: instana.com
  names:
    kind: Example
    listKind: ExampleList
    plural: examples
    singular: example
  scope: Namespaced
  version: v1alpha1
</code></pre>
<p>Apply <code>operator-example.crd.yaml</code>:</p>
<pre><code class="language-bash">kubectl apply -f operator-example.crd.yaml
</code></pre>
<p>The operator needs more access rights than in the <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-2">previous blog post</a>, because it lists and watches the custom resource and create the daemon set. Extend the <code>operator-example.clusterrole.yaml</code> file from the previous blog post as follows:</p>
<pre><code>apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: operator-example
rules:
- apiGroups:
  - apps
  resources:
  - daemonsets
  verbs:
  - list
  - get
  - create
  - update
- apiGroups:
  - extensions
  resources:
  - daemonsets
  verbs:
  - get
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - list
- apiGroups:
  - instana.com
  resources:
  - examples
  verbs:
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - list
</code></pre>
<p>Apply <code>operator-example.clusterrole.yaml</code>:</p>
<pre><code class="language-bash">kubectl apply -f operator-example.clusterrole.yaml
</code></pre>
<p>Finally, we are ready to deploy our operator. We use the <code>operator-example.deployment.yaml</code> file from the <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-2">previous blog post</a>:</p>
<pre><code>kubectl apply -f operator-example.deployment.yaml
</code></pre>
<p>The operator should start up and wait for custom resources. In order to create a custom resource, copy the example YAML from the top of this blog post into a file called <code>operator-example.cr.yaml</code> and apply it:</p>
<pre><code>kubectl apply -f operator-example.cr.yaml
</code></pre>
<p>You should see in the operator logs that the operator observed an <code>ADDED</code> event for the resource, and you should see with <code>kubectl get daemonsets</code> that a daemonset was created.</p>
<p>If you remove the custom resource with <code>kubectl delete -f operator-example.cr.yaml</code>, the daemonset should be removed as well due to the garbage collection based on owner reference, as described in the <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-1">first blog post</a>.</p>
<h2>Summary</h2>
<p>In this series, we showed how to implement a Kubernetes operator in Java, using <a href="https://quarkus.io/">Quarkus</a> and the <a href="https://quarkus.io/extensions/">Kubernetes client extension</a>. We started off with an <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-1">introduction to Kubernetes operators</a>, moved on to create our <a href="https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-2">first Quarkus project with the Kubernetes client extension</a> and finally created some more realistic operator functionality in this blog post, like watching custom resources.</p>
<p>If you want to carry on, the next steps would be to watch the Pods so that the operator knows when Pods change their status to running, and to assign the special roles to the Pods. Moreover, you might want to watch the daemonsets and re-create it if it accidentally got deleted.</p>
<p>The first alpha version of our <a href="https://github.com/instana/instana-agent-operator">Instana Agent Operator</a> is available on GitHub, so if you want to have a look at a more complete example, this might be a good reference.</p>

<div class="promotion-section-h">
<div class="wrapper">
</div>
</div>

</div>
<div class="col-lg-3 offset-xl-1 offset-md-0 col-md-12 col-sm-12 sticky-free-trial">
<div class="sticky-free-trial-inner">
<div class="sidebar-trial">
<h2>14 days, no credit card, full version</h2>
<div class="p-0"><a class="btn btn-freetrial-s" href="/trial/" role="button">Free Trial</a></div>
</div>
<div class="sidebar-webinar"><p class="widget-sidebar-title">Join our upcoming <a class="sidebar-title-link" href="/webinars/">Webinars</a></p><div class="blog-sidebar-webinar"><h3 class="sidebar-blog-title"><a href="https://www.instana.com/webinars/googlecloud-roundtable-the-saas-era/">Born-Digital Leaders roundtable &#8211; “A new Age in IT &#8211; the SaaS Era”</a></h3></div><div class="sidebar-blog-button"><a href="https://inthecloud.withgoogle.com/founders-platform-21/saas-era.html" target="_self">Register</a></div></div> <div class="col-lg-12 col-md-12 col-xs-12 nopadding">
<div class="share-bottom-inner-top">
<a class="footer__section__social__item fb-share-button" href="https://www.facebook.com/share.php?u=https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-3/&title=Writing a Kubernetes Operator in Java: Part 3" target="_blank" rel="noopener noreferrer">
<i class="fa fa-facebook fa-2x" aria-hidden="true"></i>
</a>
<a class="footer__section__social__item" href="https://twitter.com/intent/tweet?text=Writing a Kubernetes Operator in Java: Part 3%0A&url=https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-3/" target="_blank" rel="noopener noreferrer">
<i class="fa fa-twitter fa-2x" aria-hidden="true"></i>
</a>
<a class="footer__section__social__item" href="https://www.linkedin.com/shareArticle?mini=true&url=https://www.instana.com/blog/writing-a-kubernetes-operator-in-java-part-3/&title=Writing a Kubernetes Operator in Java: Part 3&summary=&source=" target="_blank" rel="noopener noreferrer">
<i class="fa fa-linkedin fa-2x" aria-hidden="true"></i>
</a>
<a class="footer__section__social__item" href="https://www.instana.com/feed/" target="_blank" rel="noopener noreferrer">
<i class="fa fa-rss fa-2x" aria-hidden="true"></i>
</a>
</div>
</div>
</div>
</div>
</div>
<div class="stop-menu"></div>
</div>
<div class="wrapper">
<div class="border-devider"></div>
</div>
<div class="form-bckground">
<div class="row">
<div class="col-lg-12 col-md-12 col-sm-12 newsletter-wrapper text-center p-4">
<h2 class="newsletter-title">Sign up for our blog updates!</h2>
<div class="newsletter-form">
<div class="sp-form-default sp-form-hide-label">
<script type="4e1c172490f29109ad76a1a3-text/javascript">
                  hbspt.forms.create({
                    portalId: "719302",
                    formId: "7d3b006f-01cd-479e-ab26-5e46b809134e",
                        target: '#hubspot-newsletter-subscription'
                });
                </script>
<div id="hubspot-newsletter-subscription"></div>
</div>
</div>
</div>
</div>
</div>

<div class="get-started w-100 d-lg-flex align-items-center">
<div class="wrapper">
<div class="row">
<div class="col-lg-12 text-center">
<h2>Play with Instana’s APM Observability Sandbox</h2>
<div class="p-0">
<a class="btn get-started-s" href="https://www.instana.com/apm-observability-sandbox/" target="_self">Play With</a>
</div>
</div>
</div>
</div>
</div>

<div class="bg-light-gray">
<div class="wrapper">
<div class="container-fluid">
<div class="row">
<div class="related-blog-title col-12"><h2>Related Blog Posts</h2></div>
<div class="col-12"><div class="blue-separator"></div></div>
<div class="col-xl-4 col-lg-4 col-md-12 col-xs-12 blog-col-h">
<div class="inner-box-l">

<div class="category-post"><a href="https://www.instana.com/blog/category/engineering/" rel="category tag">Engineering</a>, <a href="https://www.instana.com/blog/category/product/" rel="category tag">Product</a></div>
<div class="supported-tech-title"><a href="https://www.instana.com/blog/configuration-based-sdks-for-java-and-net/"><h5>Configuration-Based SDKs for Java and .NET</h5></a></div>
<div class="blog-post-excerpt">At Instana, we believe that Observability should be as automated as possible. We often joke with each other about automagic. From the birth of Instana, we relentlessly invested in the creation of...</div>
<div class="d-a-block">
<div class="post-author">By: <a href="https://www.instana.com/blog/author/michele-mancioppi/" title="Posts by Michele Mancioppi" rel="author">Michele Mancioppi</a></div> | <div class="post-date">April 13, 2021</div>
</div>
<div class="continue-reading"><a href="https://www.instana.com/blog/configuration-based-sdks-for-java-and-net/">Continue Reading <i class="fa fa-angle-right shake-horizontal" aria-hidden="true"></i></a></div>
</div>
</div>
 <div class="col-xl-4 col-lg-4 col-md-12 col-xs-12 blog-col-h">
<div class="inner-box-l">

<div class="category-post"><a href="https://www.instana.com/blog/category/developer/" rel="category tag">Developer</a>, <a href="https://www.instana.com/blog/category/thought-leadership/" rel="category tag">Thought Leadership</a></div>
<div class="supported-tech-title"><a href="https://www.instana.com/blog/excursion-into-the-kubernetes-tools-world/"><h5>The 12 Days of Kubernetes (Tools)</h5></a></div>
<div class="blog-post-excerpt">Kubernetes (also known as k8s) is an orchestration platform and abstract layer for containerized applications and services. As such, k8s manages and limits container available resources on the physical machine, as well...</div>
<div class="d-a-block">
<div class="post-author">By: <a href="https://www.instana.com/blog/author/christoph-engelbert/" title="Posts by Chris Engelbert" rel="author">Chris Engelbert</a></div> | <div class="post-date">December 18, 2020</div>
</div>
<div class="continue-reading"><a href="https://www.instana.com/blog/excursion-into-the-kubernetes-tools-world/">Continue Reading <i class="fa fa-angle-right shake-horizontal" aria-hidden="true"></i></a></div>
</div>
</div>
<div class="col-xl-4 col-lg-4 col-md-12 col-xs-12 blog-col-h">
<div class="inner-box-l">

<div class="category-post"><a href="https://www.instana.com/blog/category/announcement/" rel="category tag">Announcement</a>, <a href="https://www.instana.com/blog/category/developer/" rel="category tag">Developer</a>, <a href="https://www.instana.com/blog/category/product/" rel="category tag">Product</a></div>
<div class="supported-tech-title"><a href="https://www.instana.com/blog/instana-brings-best-in-class-observability-with-the-new-amazon-kubernetes-distribution/"><h5>Instana brings best-in-class observability with the New Amazon Kubernetes distribution</h5></a></div>
<div class="blog-post-excerpt">Co-Authored by: Evgeni Wachnowezki AWS is sharing its Amazon EKS Distro Kubernetes distribution with the community. Amazon EKS Distro is a Kubernetes distribution optimized for security and reliability, and is battle-tested by...</div>
<div class="d-a-block">
<div class="post-author">By: <a href="https://www.instana.com/blog/author/michele-mancioppi/" title="Posts by Michele Mancioppi" rel="author">Michele Mancioppi</a></div> | <div class="post-date">December 1, 2020</div>
</div>
<div class="continue-reading"><a href="https://www.instana.com/blog/instana-brings-best-in-class-observability-with-the-new-amazon-kubernetes-distribution/">Continue Reading <i class="fa fa-angle-right shake-horizontal" aria-hidden="true"></i></a></div>
</div>
</div>
</div>
</div>
</div>
</div>

<div class="trial-light w-100 d-lg-flex align-items-center">
<div class="wrapper">
<div class="row">
<div class="col-lg-12 text-center">
<h2>Start your FREE TRIAL today!</h2>
<div class="p-0"><a class="btn btn-freetrial-s" href="/trial/" role="button">Free Trial</a></div>
</div>
</div>
</div>
</div>

<div class="about-instana">
<div class="wrapper">
<div class="container-fluid">
<div class="row">
<div class="related-blog-title col-12"><h2>About Instana</h2></div>
<div class="col-12"><div class="blue-separator"></div></div>
<div class="about-instana-body-text text-center col-lg-8 col-md-12 col-sm-12 ml-auto mr-auto">
<p>Instana, an IBM company, provides an Enterprise Observability Platform with automated application monitoring capabilities to businesses operating complex, modern, cloud-native applications no matter where they reside – on-premises or in public and private clouds, including mobile devices or IBM Z.</p>
<p>Control hybrid modern applications with Instana’s AI-powered discovery of deep contextual dependencies inside hybrid applications. Instana also gives visibility into development pipelines to help enable closed-loop DevOps automation.</p>
<p>This provides actionable feedback needed for clients as they to optimize application performance, enable innovation and mitigate risk, helping Dev+Ops add value and efficiency to software delivery pipelines while meeting their service and business level objectives.</p>
<p>For further information, please visit <a href="https://wwww.instana.com">instana.com</a>.</p>
</div>
</div>
</div>
</div>
</div>
<script type="4e1c172490f29109ad76a1a3-text/javascript">
    jQuery(document).ready(function($) {
        $('.modal-trigger-experience-instana').click(function() {
            window.location.href = '/trial';
            return false;
        });
    });
</script>
<script type="4e1c172490f29109ad76a1a3-text/javascript">
    jQuery(document).ready(function($) {
      var $window = $(window);
      var $sidebar = $(".sticky-free-trial-inner");
      var $sidebarHeight = $sidebar.innerHeight();
      var $footerOffsetTop = $(".stop-menu").offset().top;
      var $sidebarOffset = $sidebar.offset();
      var isMobile = window.matchMedia("only screen and (max-width: 1024px)");

        if (isMobile.matches) {
            $window.scroll(function() {
                if($window.scrollTop() > $sidebarOffset.top) {
                  $sidebar.addClass("fixed");
                } else {
                  $sidebar.removeClass("fixed");
                }
                if($window.scrollTop() + $sidebarHeight > $footerOffsetTop) {
                  $sidebar.css({"top" : -($window.scrollTop() + $sidebarHeight - $footerOffsetTop)});
                } else {
                  $sidebar.css({"top": "85px",});
                }
            });
        } else {
            $window.scroll(function() {
                if($window.scrollTop() > $sidebarOffset.top) {
                  $sidebar.addClass("fixed");
                } else {
                  $sidebar.removeClass("fixed");
                }
                var top_of_element = $(".form-bckground").offset().top;
                var bottom_of_element = $(".form-bckground").offset().top + $(".form-bckground").outerHeight();
                var bottom_of_screen = $(window).scrollTop() + $(window).innerHeight();
                var top_of_screen = $(window).scrollTop();

                if (bottom_of_screen > (top_of_element) + 30 ){
                    $sidebar.css({"top": "-1000px",});
                }
                else {
                  $sidebar.css({"top": "115px",});
                }
            });
        }

    });
</script>
</div>


<footer id="footer" class="footer-new">
<div class="footer-inner">
<div class="footer-top">
<div class="footer-container">
<div class="row">
<div class="col-md-4 col-sm-12">
<div id="footer-sidebar1">
<aside id="nav_menu-16" class="widget widget_nav_menu"><h3 class="widget-title">Quick Links</h3><div class="menu-footer-navigation-new-container"><ul id="menu-footer-navigation-new" class="menu"><li id="menu-item-5483" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-5483"><a href="https://www.instana.com/docs/">Documentation</a></li>
<li id="menu-item-5484" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-5484"><a href="https://support.instana.com/hc/en-us">Support</a></li>
<li id="menu-item-5485" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-5485"><a href="https://www.instana.com/careers/">Careers</a></li>
<li id="menu-item-13343" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-13343"><a href="/events/">Events</a></li>
<li id="menu-item-5487" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-5487"><a href="https://www.instana.com/contact-us/">Contact Us</a></li>
</ul></div></aside> </div>
<div class="follow-us-footer">
<div class="networks-title-footer"><h3>Follow Us:</h3></div>
<div class="sp-social-networks sp-social-networks-primary social-home-new"><ul><li class="facebook"><a href="https://www.facebook.com/InstanaHQ" target="_blank" rel="noopener noreferrer" title=" Facebook"><i class="fa fa-facebook"></i></a></li><li class="twitter"><a href="https://twitter.com/InstanaHQ" target="_blank" rel="noopener noreferrer" title=" Twitter"><i class="fa fa-twitter"></i></a></li><li class="linkedin"><a href="https://www.linkedin.com/company/10082535" target="_blank" rel="noopener noreferrer" title=" LinkedIn"><i class="fa fa-linkedin"></i></a></li><li class="youtube"><a href="https://www.youtube.com/channel/UC_AAMzr7IEz8F08qzS9hMwQ" target="_blank" rel="noopener noreferrer" title=" YouTube"><i class="fa fa-youtube-play"></i></a></li></ul></div> </div>
</div>
<div class="col-md-4 col-sm-12">
<div id="footer-sidebar2">
<div class="test"><div class="row"><h3 class="widget-title col-lg-12 p-0"><a class="footer-title-link" href="/events/">Events</a></h3><div class="col-lg-12 d-flex align-items-center footer-border-bottom p-0"><div class="col-lg-9 p-0"><div class="acf-rpw-before"><p>April 21, 2021</p></div><div><h3 class="acf-rpw-title"><a href="https://gremlin.registration.goldcast.io/events/207e0873-4af1-49f4-b437-a291b3d29a6a">FAILOVER Conf.</a></h3></div></div><div class="col-lg-3 p-0"><div class="acf-rpw-after-2"><a href="https://gremlin.registration.goldcast.io/events/207e0873-4af1-49f4-b437-a291b3d29a6a">Register</a></div></div></div><div class="col-lg-12 d-flex align-items-center footer-border-bottom p-0"><div class="col-lg-9 p-0"><div class="acf-rpw-before"><p>April 21, 2021</p></div><div><h3 class="acf-rpw-title"><a href="https://cloudopsummit.com/?utm_campaign=CloudOps%20Summit%20-%20April%202020%20-%20Instana&utm_source=email&utm_medium=Instana%20email&utm_content=Instana%20promo">CloudOps Summit</a></h3></div></div><div class="col-lg-3 p-0"><div class="acf-rpw-after-2"><a href="https://cloudopsummit.com/?utm_campaign=CloudOps%20Summit%20-%20April%202020%20-%20Instana&utm_source=email&utm_medium=Instana%20email&utm_content=Instana%20promo">Register</a></div></div></div><div class="col-lg-12 d-flex align-items-center footer-border-bottom p-0"><div class="col-lg-9 p-0"><div class="acf-rpw-before"><p>April 27-28, 2021</p></div><div><h3 class="acf-rpw-title"><a href="https://www.redhat.com/en/summit">Red Hat Summit &#8211; Part 1</a></h3></div></div><div class="col-lg-3 p-0"><div class="acf-rpw-after-2"><a href="https://www.redhat.com/en/summit">Register</a></div></div></div></div></div> </div>
</div>
<div class="col-md-4 col-sm-12">
 <div id="footer-sidebar3">
<div class="test"><h3 class="widget-title"><a class="footer-title-link" href="/webinars/">Webinars</a></h3><div class="acf-rpw-before"><p>April 29, 2021 17:00 CEST</p></div><div><h3 class="acf-rpw-title"><a href="https://www.instana.com/webinars/googlecloud-roundtable-the-saas-era/">Born-Digital Leaders roundtable &#8211; “A new Age in IT &#8211; the SaaS Era”</a></h3></div><div class="acf-rpw-excerpt">Part 3: Writing a Kubernetes Operator in Java In the previous post of this series, we created an example Quarkus project using the Kubernetes client extension. The example retrieved a<p class="more-link"><a class="more-link" href="https://www.instana</div><div class=" acf-rpw-after"><a href="https://inthecloud.withgoogle.com/founders-platform-21/saas-era.html">Register</a></div></div> </div>
</div>
</div>
</div>
<div class="footer-container footer-m">
<div class="menu-footer-navigation-secondary-container"><ul id="menu-footer-navigation-secondary" class="navigation"><li id="menu-item-2637" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-2637"><a href="https://www.instana.com/contact-us/">Contact Us</a></li>
<li id="menu-item-12585" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-12585"><a href="https://www.instana.com/copyright-policy/">Copyright Policy</a></li>
<li id="menu-item-12588" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-12588"><a href="https://www.instana.com/privacy-policy/">Privacy Policy</a></li>
<li id="menu-item-12586" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-12586"><a href="https://www.instana.com/cookie-policy/">Cookie Policy</a></li>
<li id="menu-item-1544" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-1544"><a href="https://www.instana.com/security/">Information Security &#038; Data Compliance</a></li>
<li id="menu-item-12590" class="menu-item menu-item-type-post_type menu-item-object-page menu-item-12590"><a href="https://www.instana.com/terms-of-use/">Terms of Use</a></li>
</ul></div> </div>
</div>
</div>
</footer>

<style>.footer-new .acf-rpw-before{order:0!important}#hubspot-messages-iframe-container{z-index:999999999!important}</style>

<script type="4e1c172490f29109ad76a1a3-text/javascript" id="hs-script-loader" async defer data-type="lazy" data-src="//js.hs-scripts.com/719302.js"></script>
<div id="responsive-menu-pro-header">
<div id="responsive-menu-pro-header-bar-items-container">
<div id="responsive-menu-pro-header-bar-logo" class="responsive-menu-pro-header-bar-item responsive-menu-pro-header-box"> <a href="https://www.instana.com/">
<img alt="Logo" data-src="https://www.instana.com/media/INSTANA-logo.svg" class="lazyload" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" /><noscript><img alt="Logo" src="https://www.instana.com/media/INSTANA-logo.svg" /></noscript> </a>
</div> </div>
</div>
<div id="responsive-menu-pro-header-bar-button" class="responsive-menu-pro-header-box">
<button id="responsive-menu-pro-button" tabindex="1" class="responsive-menu-pro-button responsive-menu-pro-boring responsive-menu-pro-accessible" type="button" aria-label="Menu">
<span class="responsive-menu-pro-box"><span class="responsive-menu-pro-inner"></span>
</span></button> </div><div id="responsive-menu-pro-container" class="slide-left">
<div id="responsive-menu-pro-wrapper" role="navigation" aria-label="header-navigation-v6"> <div id="responsive-menu-pro-title"> <div id="responsive-menu-pro-title-image"><img alt="" data-src="https://www.instana.com/media/INSTANA-logo.svg" class="lazyload" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" /><noscript><img alt="" src="https://www.instana.com/media/INSTANA-logo.svg" /></noscript></div> </div><ul id="responsive-menu-pro" role="menubar" aria-label="header-navigation-v6"><li id="responsive-menu-pro-item-14391" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children responsive-menu-pro-desktop-menu-col-auto" role="none"><a class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Platform<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Platform' role='menu' data-depth='2' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-1'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14392" class="sp-navigation-dropdown-panel-column-1 sp-navigation-item-block  menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children" role="none"><a href="#" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Enterprise Observability<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Enterprise Observability' role='menu' data-depth='3' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-2'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14393" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/enterprise-observability-platform" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Enterprise Observability Platform</a></li><li id="responsive-menu-pro-item-14394" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/automated-application-performance-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Application Performance Monitoring</a></li><li id="responsive-menu-pro-item-14395" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/website-end-user-monitoring" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Web Site Monitoring</a></li><li id="responsive-menu-pro-item-14396" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/cloud-and-infrastructure-monitoring" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Cloud &#038; Infrastructure Monitoring</a></li><li id="responsive-menu-pro-item-14397" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/microservices-apm" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Microservices Monitoring</a></li></ul></li><li id="responsive-menu-pro-item-14398" class="drop-down-company sp-navigation-dropdown-panel-column-1 sp-navigation-item-block menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children" role="none"><a href="/supported-technologies/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Supported Technologies<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Supported Technologies' role='menu' data-depth='3' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-2'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14399" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">All Technologies</a></li><li id="responsive-menu-pro-item-14400" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/blog/supported-technology-type/tracing-supported-languages-frameworks/application-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Languages</a></li><li id="responsive-menu-pro-item-14401" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/blog/supported-technology-type/cloud-operations/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Cloud Platforms</a></li><li id="responsive-menu-pro-item-14402" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/compute-engine-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Google Cloud Platform</a></li><li id="responsive-menu-pro-item-14403" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/aws-ec2-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Amazon AWS</a></li><li id="responsive-menu-pro-item-14404" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/microsoft-azure-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Microsoft Azure</a></li><li id="responsive-menu-pro-item-14405" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/ibm-bluemix-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">IBM Cloud / Red Hat Marketplace</a></li></ul></li><li id="responsive-menu-pro-item-14406" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children" role="none"><a href="#" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Kubernetes Distributions<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Kubernetes Distributions' role='menu' data-depth='3' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-2'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14407" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/google-gke-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Google GKE</a></li><li id="responsive-menu-pro-item-14408" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/openshift-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Red Hat OpenShift</a></li><li id="responsive-menu-pro-item-14409" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/pivotal-container-service-pks-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">VMware Tanzu</a></li><li id="responsive-menu-pro-item-14410" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/amazon-eks-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">AWS EKS</a></li><li id="responsive-menu-pro-item-14411" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/azure-aks-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Azure AKS</a></li></ul></li></ul></li><li id="responsive-menu-pro-item-14412" class="solutions-menu-item menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children responsive-menu-pro-desktop-menu-col-auto" role="none"><a class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Solutions<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Solutions' role='menu' data-depth='2' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-1'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14413" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children" role="none"><a href="#" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Observability and Monitoring<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Observability and Monitoring' role='menu' data-depth='3' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-2'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14414" class="menu-item menu-item-type-post_type menu-item-object-page responsive-menu-pro-item" role="none"><a href="https://www.instana.com/apm-for-microservices/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Microservices Observability</a></li><li id="responsive-menu-pro-item-14415" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/apm-for-containers/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Container Observability</a></li><li id="responsive-menu-pro-item-14416" class="menu-item menu-item-type-post_type menu-item-object-page responsive-menu-pro-item" role="none"><a href="https://www.instana.com/apm-for-service-oriented-architectures/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Monitoring SOA</a></li><li id="responsive-menu-pro-item-14417" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/observability-for-hybrid-cloud-applications/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Monitoring Hybrid Cloud</a></li><li id="responsive-menu-pro-item-14418" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="#" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Monitoring Multi-Cloud</a></li><li id="responsive-menu-pro-item-14419" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/automatic-kubernetes-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Kubernetes Monitoring</a></li><li id="responsive-menu-pro-item-14420" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/automatic-root-cause-analysis/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Automatic Root Cause Analysis</a></li></ul></li><li id="responsive-menu-pro-item-14421" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children" role="none"><a href="#" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Open Source Standards<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Open Source Standards' role='menu' data-depth='3' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-2'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14422" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/jaeger-apm-integration/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Jaeger</a></li><li id="responsive-menu-pro-item-14423" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/opentracing/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">OpenTracing</a></li><li id="responsive-menu-pro-item-14424" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/docs/ecosystem/prometheus/#main" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Prometheus</a></li><li id="responsive-menu-pro-item-14425" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/docs/ecosystem/opentelemetry/#main" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Open Telemetry</a></li><li id="responsive-menu-pro-item-14426" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/zipkin-apm-integration/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Zipkin</a></li></ul></li><li id="responsive-menu-pro-item-14427" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children" role="none"><a class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Kubernetes Distributions<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Kubernetes Distributions' role='menu' data-depth='3' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-2'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14428" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/google-gke-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Google GKE</a></li><li id="responsive-menu-pro-item-14429" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/openshift-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Red Hat OpenShift</a></li><li id="responsive-menu-pro-item-14430" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/pivotal-container-service-pks-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">VMware Tanzu</a></li><li id="responsive-menu-pro-item-14431" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/amazon-eks-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">AWS EKS</a></li><li id="responsive-menu-pro-item-14432" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/azure-aks-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Azure AKS</a></li><li id="responsive-menu-pro-item-14433" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/automatic-kubernetes-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Kubernetes Monitoring</a></li></ul></li><li id="responsive-menu-pro-item-14434" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children" role="none"><a href="#" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Roles<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Roles' role='menu' data-depth='3' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-2'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14435" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/observability-and-application-monitoring-for-site-reliability-engineers-sres/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">SRE</a></li><li id="responsive-menu-pro-item-14436" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/observability-and-application-monitoring-for-devops/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">DevOps</a></li><li id="responsive-menu-pro-item-14437" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/observability-and-application-monitoring-for-developers/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Developers</a></li><li id="responsive-menu-pro-item-14438" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/observability-and-application-monitoring-for-it-managers-and-executives/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Executives</a></li></ul></li><li id="responsive-menu-pro-item-14439" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children" role="none"><a href="#" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Cloud Platforms<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Cloud Platforms' role='menu' data-depth='3' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-2'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14440" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/gcp-observability-and-application-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Google Cloud Platforms (GCP)</a></li><li id="responsive-menu-pro-item-14441" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/microsoft-azure-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Microsoft Azure</a></li><li id="responsive-menu-pro-item-14442" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/aws-observability-and-application-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Amazon AWS</a></li><li id="responsive-menu-pro-item-14443" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/supported-technologies/ibm-bluemix-monitoring/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">IBM Cloud</a></li></ul></li></ul></li><li id="responsive-menu-pro-item-14444" class="menu-item menu-item-type-post_type menu-item-object-page responsive-menu-pro-item responsive-menu-pro-desktop-menu-col-auto" role="none"><a href="https://www.instana.com/how-instana-dynamic-apm-works/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Why Instana?</a></li><li id="responsive-menu-pro-item-14445" class="menu-item menu-item-type-post_type menu-item-object-page responsive-menu-pro-item responsive-menu-pro-desktop-menu-col-auto" role="none"><a href="https://www.instana.com/pricing/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Pricing</a></li><li id="responsive-menu-pro-item-14446" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children responsive-menu-pro-desktop-menu-col-auto" role="none"><a class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Resources<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Resources' role='menu' data-depth='2' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-1'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14449" class="drop-down-company sp-navigation-dropdown-panel-column-2 sp-navigation-item-block menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/resources/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Whitepapers and eBooks</a></li><li id="responsive-menu-pro-item-14618" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/customers/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Customer Success Stories</a></li><li id="responsive-menu-pro-item-14448" class="drop-down-company sp-navigation-dropdown-panel-column-1 sp-navigation-item-block menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/webinars/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Webinars</a></li><li id="responsive-menu-pro-item-14619" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/training-resources/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Video Guides</a></li><li id="responsive-menu-pro-item-14471" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/events/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Events</a></li><li id="responsive-menu-pro-item-14450" class="drop-down-company sp-navigation-dropdown-panel-column-2 sp-navigation-item-block menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/blog/category/engineering/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Engineering Blog</a></li><li id="responsive-menu-pro-item-14451" class="drop-down-company sp-navigation-dropdown-panel-column-2 sp-navigation-item-block menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a target="_blank" rel="noopener" href="https://docs.instana.com/?__hstc=1833966.97fec7c5f19d190df82ea098ec630fbf.1541082789840.1544080364506.1544165984612.26&#038;__hssc=1833966.6.1549354890660&#038;__hsfp=2988742834" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Documentation</a></li></ul></li><li id="responsive-menu-pro-item-14452" class="menu-item menu-item-type-custom menu-item-object-custom menu-item-has-children responsive-menu-pro-item responsive-menu-pro-item-has-children responsive-menu-pro-desktop-menu-col-auto" role="none"><a class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Company<div class="responsive-menu-pro-subarrow"><span class="fas fa-angle-right"></span></div></a><ul aria-label='Company' role='menu' data-depth='2' class='responsive-menu-pro-submenu responsive-menu-pro-submenu-depth-1'><div class="responsive-menu-pro-back"><span class="fas fa-angle-left"></span> Back</div><li id="responsive-menu-pro-item-14453" class="menu-item menu-item-type-post_type menu-item-object-page responsive-menu-pro-item" role="none"><a href="https://www.instana.com/company/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Background and Vision</a></li><li id="responsive-menu-pro-item-14469" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/partners" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Partners</a></li><li id="responsive-menu-pro-item-14455" class="drop-down-company sp-navigation-dropdown-panel-column-1 sp-navigation-item-block menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/customers/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Customers</a></li><li id="responsive-menu-pro-item-14456" class="drop-down-company sp-navigation-dropdown-panel-column-1 sp-navigation-item-block menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/announcements/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Announcements</a></li><li id="responsive-menu-pro-item-14457" class="drop-down-company sp-navigation-dropdown-panel-column-2 sp-navigation-item-block menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/newsroom/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Newsroom</a></li><li id="responsive-menu-pro-item-14458" class="menu-item menu-item-type-post_type menu-item-object-page responsive-menu-pro-item" role="none"><a href="https://www.instana.com/careers/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Careers</a></li><li id="responsive-menu-pro-item-14459" class="menu-item menu-item-type-post_type menu-item-object-page responsive-menu-pro-item" role="none"><a href="https://www.instana.com/contact-us/" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Contact Us</a></li></ul></li><li id="responsive-menu-pro-item-14844" class="menu-item menu-item-type-custom menu-item-object-custom responsive-menu-pro-item" role="none"><a href="/blog" class="responsive-menu-pro-item-link" tabindex="1" role="menuitem">Blog</a></li></ul><div id="responsive-menu-pro-search-box">
<form action="https://www.instana.com" class="responsive-menu-pro-search-form" role="search">
<input type="search" name="s" title="Search" tabindex="1" placeholder="Search" class="responsive-menu-pro-search-box">
</form>
</div>
<div id="responsive-menu-pro-additional-content"><div class="p-0">
<a class="btn btn-freetrial-s" href="/trial/" target="">Free Trial</a>
</div></div> </div>
</div><script type="4e1c172490f29109ad76a1a3-text/javascript" id='cookie-consent-js-extra'>
/* <![CDATA[ */
var ctcc_vars = {"expiry":"30","method":"","version":"1"};
/* ]]> */
</script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/cache/asset-cleanup/js/item/cookie-consent-v9e4f3f2852987ce767a8db24b57d640f8b31bf1d.js' id='cookie-consent-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-includes/js/jquery/ui/core.min.js?ver=1.12.1' id='jquery-ui-core-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-includes/js/jquery/ui/datepicker.min.js?ver=1.12.1' id='jquery-ui-datepicker-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" id='jquery-ui-datepicker-js-after'>
jQuery(document).ready(function(jQuery){jQuery.datepicker.setDefaults({"closeText":"Close","currentText":"Today","monthNames":["January","February","March","April","May","June","July","August","September","October","November","December"],"monthNamesShort":["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],"nextText":"Next","prevText":"Previous","dayNames":["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],"dayNamesShort":["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],"dayNamesMin":["S","M","T","W","T","F","S"],"dateFormat":"MM d, yy","firstDay":1,"isRTL":false});});
</script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/plugins/wp-smush-pro/app/assets/js/smush-lazy-load.min.js?ver=3.8.4' id='smush-lazy-load-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/js/single-blog.js?ver=2.0.0' id='single-blog-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-includes/js/hoverIntent.min.js?ver=1.8.1' id='hoverIntent-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" id='megamenu-js-extra'>
/* <![CDATA[ */
var megamenu = {"timeout":"300","interval":"100"};
/* ]]> */
</script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/cache/asset-cleanup/js/item/megamenu-vdf53538cd679f845d87a7ca494bbffbaf3933428.js' id='megamenu-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-includes/js/wp-embed.min.js?ver=5.7.1' id='wp-embed-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" id='sp-front-js-extra'>
/* <![CDATA[ */
var STIMPACK = {"version":"1.852","ajaxUrl":"https:\/\/www.instana.com\/wp-admin\/admin-ajax.php","breakpoints":{"sm":544,"md":768,"lg":992,"xl":1200},"geolocation":{"country":"CN","continent":null},"hubspotPortalId":"719302"};
/* ]]> */
</script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" src='https://www.instana.com/wp-content/themes/Instana%20Inc/assets/js/front.min.js?ver=1.852' id='sp-front-js'></script>
<script type="4e1c172490f29109ad76a1a3-text/javascript" id="flying-scripts">const loadScriptsTimer=setTimeout(loadScripts,3*1000);const userInteractionEvents=["mouseover","keydown","touchstart","touchmove","wheel"];userInteractionEvents.forEach(function(event){window.addEventListener(event,triggerScriptLoader,{passive:!0})});function triggerScriptLoader(){loadScripts();clearTimeout(loadScriptsTimer);userInteractionEvents.forEach(function(event){window.removeEventListener(event,triggerScriptLoader,{passive:!0})})}
function loadScripts(){document.querySelectorAll("script[data-type='lazy']").forEach(function(elem){elem.setAttribute("src",elem.getAttribute("data-src"))})}</script>

<script type="4e1c172490f29109ad76a1a3-text/javascript">
(function($) {
 $(document).ready(function() {
    $('form').find(':input').blur(function() {
      if (this.value === this.defaultValue) {
        var inputAction = 'skipped';
      } else {
        var inputAction = this.value ? 'completed' : 'skipped';
      }
                // compatible with post-5.0 Yoast-specific Universal GA code
                if (typeof __gaTracker !== 'undefined') {
                    __gaTracker('send', 'event', (this.form.id || 'form-without-id'), inputAction, $(this).attr('name'));
                //    console.log('Form Abandonment Tracking - __gaTracker Universal in use, sent: ' + (this.form.id || 'form-without-id') + ' Label: ' + this.name + ' Action: ' + inputAction);
                }
                //check if old _gaq is set - not Universal Analytics
                if (typeof _gaq !== 'undefined') {
                    _gaq.push(['_trackEvent', (this.form.id || 'form-without-id'), inputAction, $(this).attr('name')]);
                //    console.log('Form Abandonment Tracking - Google Analytics in use, sent: ' + (this.form.id || 'form-without-id') + ' Label: ' + this.name + ' Action: ' + inputAction);
                }
                // compatible with pre-5.1 Yoast GA code or for sites with manual Universal Analytics code added
                if (typeof ga !== 'undefined') {
                    ga('send', 'event', (this.form.id || 'form-without-id'), inputAction, $(this).attr('name'));
                //    console.log('Form Abandonment Tracking - Orig Universal in use, sent: ' + (this.form.id || 'form-without-id') + ' Label: ' + this.name + ' Action: ' + inputAction);
                }
  });
  $('form').find(':input').click(function() {
    if(this.type && this.type.toLowerCase() === 'submit') {
      inputAction = 'submitted';
                // compatible with post-5.0 Yoast Universal GA code
                if (typeof __gaTracker !== 'undefined') {
                    __gaTracker('send', 'event', (this.form.id || 'form-without-id'), inputAction, $(this).attr('name'));
                //    console.log('Form Abandonment Tracking - __gaTracker Universal in use, sent: ' + (this.form.id || 'form-without-id') + ' Label: ' + this.name + ' Action: ' + inputAction);
                }
                //check if _gaq is set too
                if (typeof _gaq !== 'undefined') {
                    _gaq.push(['_trackEvent', (this.form.id || 'form-without-id'), inputAction, $(this).attr('name')]);
                //    console.log('Form Abandonment Tracking - Google Analytics in use, sent: ' + (this.form.id || 'form-without-id') + ' Label: ' + this.name + ' Action: ' + inputAction);
                }
                // compatible with pre-5.1 Yoast GA code, for sites that are neglected lol
                if (typeof ga !== 'undefined') {
                    ga('send', 'event', (this.form.id || 'form-without-id'), inputAction, $(this).attr('name'));
                //    console.log('Form Abandonment Tracking - Orig Universal in use, sent: ' + (this.form.id || 'form-without-id') + ' Label: ' + this.name + ' Action: ' + inputAction);
                }
    }
 });
 });
})(jQuery);
</script>

<script type="4e1c172490f29109ad76a1a3-text/javascript">
					jQuery(document).ready(function($){
												if(!catapultReadCookie("catAccCookies")){ // If the cookie has not been set then show the bar
							$("html").addClass("has-cookie-bar");
							$("html").addClass("cookie-bar-bottom-bar");
							$("html").addClass("cookie-bar-bar");
													}
																	});
				</script>
<div id="catapult-cookie-bar" class="use_x_close float-accept"><div class="ctcc-inner instana-cookie"><span class="ctcc-left-side">Instana uses cookies to allow us to better understand how the site is used. By continuing to use this site, you consent to this policy. <a class="ctcc-more-info-link" tabindex=0 target="_blank" href="https://www.instana.com/privacy-policy/">Learn more</a></span><span class="ctcc-right-side"></span><div class="x_close"><span></span><span></span></div></div></div>
<script type="4e1c172490f29109ad76a1a3-text/javascript" data-type="lazy" data-src="data:text/javascript;base64,CiAgICAgICAgICAgICAgKGZ1bmN0aW9uKGEsbCxiLGMscixzKXtfblFjPWMscj1hLmNyZWF0ZUVsZW1lbnQobCkscz1hLmdldEVsZW1lbnRzQnlUYWdOYW1lKGwpWzBdO3IuYXN5bmM9MTsKICAgICAgICAgICAgICByLnNyYz1sLnNyYz0oImh0dHBzOiI9PWEubG9jYXRpb24ucHJvdG9jb2w/Imh0dHBzOi8vIjoiaHR0cDovLyIpK2I7cy5wYXJlbnROb2RlLmluc2VydEJlZm9yZShyLHMpOwogICAgICAgICAgICAgIH0pKGRvY3VtZW50LCJzY3JpcHQiLCJzZXJ2ZS5hbGJhY3Jvc3MuY29tL3RyYWNrLmpzIiwiODkyODU0ODIiKTsKICAgICAgICAgICAg"></script>

<script src="https://ajax.cloudflare.com/cdn-cgi/scripts/7089c43e/cloudflare-static/rocket-loader.min.js" data-cf-settings="4e1c172490f29109ad76a1a3-|49" defer=""></script></body>
</html>
