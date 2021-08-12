# 使用 Heroku 部署 Xray 高性能代理服务，通过 Vless + WS 协议传输，并配置 Web 网站。

> 提醒： 滥用可能导致账户被BAN！！！

## 概述

用于在 Heroku 上部署 Vless + Websocket + Tls，每次部署自动选择最新的 Alpine Linux 和 Xray-core 。

Vless 性能更加优秀，占用资源更少。

  * 使用 [Xray](https://github.com/XTLS/Xray-core) + Caddy 同时部署，并默认已配置好 Web 网站；
  * 可通过自定义网络配置文件启动 Xray 和 Caddy，按需配置各种功能。

**Heroku 为我们提供了免费的容器服务，我们不应该滥用它，所以本项目不宜做为长期大流量使用。**

## 镜像

本镜像不会因为大量占用资源而被封号。注册好 Heroku 账号并登录后，点击下面按钮便可部署。

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://dashboard.heroku.com/new?template=https://github.com/xxunet/heroku-xray-web) 

点击上面紫色 `Deploy to Heroku`，会跳转到 Heroku App 创建页面，填上应用的名称，选择节点(建议用欧洲节点，美国节点会自动删除 YouTube 评论与点赞！)，按需修改部分参数和 UUID 后，点击下面 `Deploy app` 开始部署应用。

如出现错误，可以多尝试几次，待部署完成后页面底部会显示 `Your app was successfully deployed.`。

  * 点击 Manage App 可在 Settings 下的 Config Vars 项查看和重新设置参数；
  * 点击 Open app 跳转至应用页面，域名为 Heroku 分配的二级域名，格式为 `xxx.herokuapp.com`，用于客户端连接；
  * 默认 UUID 为 `988d75e5-a72c-48a6-9488-62ff1bbba8d8`，WS 路径为 `/xws`。

**Xray 将在部署时自动安装最新版本。**

**出于安全考量，除非使用 CDN，否则请不要使用自定义域名，而使用 Heroku 分配的二级域名，以实现 Xray Vless + Websocket + Tls。**

  * 务必替换 `xxx.herokuapp.com` 为 Heroku 分配的项目域名；
  * 务必替换部署时的默认 UUID。

## 流量中转

  <summary>可以使用 Cloudflare 的 Workers 来中转流量，配置为：</summary>
  
  ```js
  const SingleDay = 'xxx.herokuapp.com';
  const DoubleDay = 'xxx.herokuapp.com';
  addEventListener(
      "fetch", event => {
          let nd = new Date();
          if (nd.getDate() % 2) {
              host = SingleDay;
          } else {
              host = DoubleDay;
          }
          let url = new URL(event.request.url);
          url.hostname = host;
          let request = new Request(url, event.request);
          event.respondWith(
              fetch(request)
          )
      }
  )
  ```

## Xray 默认配置

  ```bash
    * 协议：Vless
    * 地址：自选 IP
    * 端口：443
    * 默认UUID：988d75e5-a72c-48a6-9488-62ff1bbba8d8
    * 加密：none
    * 传输协议：ws
    * 伪装类型：none
    * 伪装域名：xxx.workers.dev (Cloudflare Workers 反代地址)
    * 路径：/xws
    * 底层传输安全：tls
    * 跳过证书验证：false
    * SNI：xxx.workers.dev (Cloudflare Workers 反代地址)
  ```
