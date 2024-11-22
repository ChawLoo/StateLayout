# StateLayout (DevEco-5.0.3.900)

## 简介

[StateLayout](https://github.com/ChawLoo/StateLayout.git) ，是一个针对HarmonyOS Next系统开发的缺省页框架，简单、实用、高效。

- 根据状态显示对应状态页面
- 可以全局配置状态页样式

## 下载安装

```
ohpm i @chawloo/state-layout
```
## 稳定版本
| 版本     | 说明                                   |
|:-------|:-------------------------------------|
| V1.2.2 | V1版本，用的都是@Component、@State、@Link等    |
| V2.0.2 | V2版本，用的都是@ComponentV2、@Local、@Param等 |

## 尝鲜版本(时间精力有限，故暂不考虑对V1进行尝鲜功能升级)
| 版本     | 说明                    |
|:-------|:----------------------|
| V2.1.0 | 新增全局Builder功能，具体看更新说明 |


OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 接口和属性列表
### `StateConfig`属性列表

| 属性                   | 类型            | 默认值                              | 描述          |
|:---------------------|:--------------|:---------------------------------|:------------|
| defaultState         | StateEnum     | StateEnum.CONTENT                | 默认缺省页       |
| showLoadingWhenRetry | boolean       | true                             | 重试自动显示加载中   |
| loadingStr           | string        | '加载中...'                         | 加载缺省页提示文本   |
| progressColor        | ResourceColor | #FF3369E7                        | 加载缺省页进度条颜色  |
| emptyStr             | string        | '暂无数据'                           | 空白缺省页提示文本   |
| emptyIcon            | string        | $r('app.media.ic_state_empty')   | 空白缺省页图标     |
| errorStr             | string        | '加载失败'                           | 错误缺省页提示文本   |
| errorIcon            | Resource      | $r('app.media.ic_state_error')   | 错误缺省页图标     |
| networkErrorStr      | string        | '网络不稳定，请重试'                      | 网络错误缺省页提示文本 |
| networkErrorIcon     | Resource      | $r('app.media.ic_state_network') | 网络错误缺省页图标   |
| retryStr             | string        | '重新加载'                           | 重试按钮文本      |

### 全局配置`globalStateConfig`配置接口
 ⚠️ V1.1.0 版本已废弃删除这些方法，新增`globalStateConfig`直接静态赋值

| 接口                                   | 描述                    |
|:-------------------------------------|:----------------------|
| loadingConfig(LoadingConfig)         | 配置加载中的提示文案和Progress颜色 |
| emptyConfig(EmptyConfig)             | 配置空白页的提示文案和图标         |
| errorConfig(ErrorConfig)             | 配置错误中的提示文案、图标和重试文本    |
| networkErrConfig(NetworkErrorConfig) | 配置网络错误中的提示文案、图标和重试文本  |

## 全局配置
可在任意地方配置，推荐`EntryAbility`入口Ability中配置
```typescript
//在onCreate中配置即可
onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
  //全局配置缺省页的各种图标和文案
  GlobalStateConfig.progressColor = Color.Red// 设置加载中进度条的颜色
  GlobalStateConfig.emptyStr = '我是全局配置的空白提示文案'// 设置空白文案
  GlobalStateConfig.emptyIcon = $r('app.media.state_empty')// 设置空白Icon图标
  GlobalStateConfig.retryStr = '立即重试'// 设置默认重试按钮文案（网络错误和错误共享）
  GlobalStateConfig.defaultState = StateEnum.LOADING// 设置默认缺省页为加载中
  GlobalStateConfig.showLoadingWhenRetry:boolean = false// 关闭点击重试按钮自动切换加载中
}
```
### V2.1.0 新增内容
在EntryAbility中配置全局Builder，去自定义缺省页的内容,仍然支持emptyConfig,也可以不用理会这个入参，因为全局Builder必须有入参
```typescript
@Builder
function GlobalEmptyBuilder(emptyConfig?: EmptyConfig) {
  Text(`我是全局配置的EmptyBuilder:::${emptyConfig?.emptyStr}`)
}

export default class EntryAbility extends UIAbility{
  //····省略其他内容
  //在配置GlobalStateConfig的地方配置，我是放在onCreate
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    //···其他配置
    GlobalStateConfig.globalEmptyBuilder = wrapBuilder(GlobalEmptyBuilder)
  }
}
```


## 控制器 `StateController`
重要的写前面，机制问题，建议在onAppear()方法中用控制器切换缺省页，如果放在aboutToAppear()或其他过早生命周期里面的话，会因为绘制时序问题导致切换失败

| 接口                               | 描述               |
|:---------------------------------|:-----------------|
| loading(LoadingConfig)           | 显示加载中(可单次配置)     |
| empty(EmptyConfig)               | 显示空白缺省页(可单次配置)   |
| error(ErrorConfig)               | 显示错误缺省页(可单次配置)   |
| networkError(NetworkErrorConfig) | 显示网络错误缺省页(可单次配置) |
| content()                        | 显示内容页            |

## 单次配置接口
#### `LoadingConfig`

| 配置项           | 类型            | 描述    |
|:--------------|:--------------|:------|
| loadingStr    | string        | 加载中文案 |
| progressColor | ResourceColor | 进度条颜色 |

#### `EmptyConfig`

| 配置项       | 类型       | 描述   |
|:----------|:---------|:-----|
| emptyStr  | string   | 空白文案 |
| emptyIcon | Resource | 空白图标 |

#### `ErrorConfig`

| 配置项                  | 类型       | 描述         |
|:---------------------|:---------|:-----------|
| errorStr             | string   | 空白文案       |
| errorIcon            | Resource | 空白图标       |
| retryStr             | string   | 重试文案       |
| showLoadingWhenRetry | boolean  | 重试自动显示加载中  |
| isCoverRetry         | boolean  | 是否覆盖原有重试事件 |
| retry                | ()=>void | 重试事件       |

#### `NetworkErrorConfig`

| 配置项                  | 类型       | 描述         |
|:---------------------|:---------|:-----------|
| networkErrorStr      | string   | 网络错误文案     |
| networkErrorIcon     | Resource | 网络错误图标     |
| retryStr             | string   | 重试文案       |
| showLoadingWhenRetry | boolean  | 重试自动显示加载中  |
| isCoverRetry         | boolean  | 是否覆盖原有重试事件 |
| retry                | ()=>void | 重试事件       |

## 使用

#### 简单用法
```typescript
@Entry
@ComponentV2
struct Index {
  controller: StateController = new StateController() //初始化StateController
  @Local message: string = 'Hello World'
  

  aboutToAppear(): void {
    this.loading()
  }

  //模拟网络加载
  loading() {
    setTimeOut(() => {
      //简单设置状态
      this.controller.content()
    }, 2000)
  }

  build() {
    Column() {
      SelectTitleBar({
        options: [
          { value: '加载中' },
          { value: '空白页（全局文案和图标）' },
          { value: '空白页（单例文案和图标）' },
          { value: '错误页' },
          { value: '错误页（单例重试按钮和事件）' },
          { value: '错误页（单例重试事件并覆盖）' },
          { value: '没有网络' },
          { value: '没有网络（自动显示加载）' },
          { value: '没有网络（不自动显示加载）' },
          { value: '未登录' },
          { value: '加载成功' },
        ],
        subtitle: '如果设置了全局Builder,则完全自定义',
        onSelected: (index) => {
          switch (index) {
            case 0:
              this.controller.loading()
              break
            case 1:
              this.controller.empty()
              break
            case 2:
              this.controller.empty({
                emptyStr: '我是单例空白文案',
                emptyIcon: $r('app.media.state_empty')
              })
              break
            case 3:
              this.controller.error()
              break
            case 4:
              this.controller.error({
                retryStr: '我是单例错误按钮',
                errorStr: `我是单例错误文案`,
                isCoverRetry: false, //不会覆盖
                retry: () => {
                  promptAction.showToast({ message: '我是单例重试事件' })
                }
              })
              break
            case 5:
              this.controller.error({
                retryStr: '给我重试',
                errorStr: '单例重试事件，后续点击重试，执行覆盖的重试',
                isCoverRetry: true, //覆盖原来的重试，普通的error和netError后，重试时间被覆盖
                retry: () => {
                  promptAction.showToast({ message: '我是覆盖的重试事件' })
                }
              })
              break
            case 6:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试根据全局配置是否自动加载中）',
              })
              break
            case 7:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试自动显示加载中）',
                showLoadingWhenRetry: true
              })
              break
            case 8:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试不会自动显示加载中）',
                showLoadingWhenRetry: false
              })
              break
            case 9:
              this.controller.error({
                errorStr: '未登录状态提示，等同于Error',
                retryStr: '立即登录',
                showLoadingWhenRetry: false,
                retry: () => {
                  promptAction.showToast({
                    message: '跳转登录的点击事件'
                  })
                }
              })
              break
            case 10:
              this.controller.content()
              break
          }
        },
        hidesBackButton: true
      })
      Row() {
        StateLayout({
          controller: this.controller,
          retry: () => {
            promptAction.showToast({ message: '我是最初重试事件' })
            this.loading()
          },
        }) {
          Column() {
            Text(`加载成功后的内容:::${this.message}(点击文案跳转直接修改的方案)`)
              .fontSize(30)
              .fontColor(Color.Black)
              .onClick(() => {
                router.pushUrl({
                  url: "pages/StateLayoutPage"
                })
              })
          }
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .width('100%')
        }
      }
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}
```

#### 通过控制器调用切换缺省状态

```typescript
@Entry
@ComponentV2
struct Index {
  @Local message: string = 'Hello World';
  controller: StateController = new StateController()

  aboutToAppear(): void {
    this.loading()
  }

  //模拟网络加载
  loading() {
    const timerId = setInterval(() => {
      this.controller.content()
      clearInterval(timerId)
    }, 2000)
  }

  build() {
    Column() {
      SelectTitleBar({
        options: [
          { value: '加载中' },
          { value: '空白页（全局文案和图标）' },
          { value: '空白页（单例文案和图标）' },
          { value: '错误页' },
          { value: '错误页（单例重试按钮和事件）' },
          { value: '错误页（单例重试事件并覆盖）' },
          { value: '没有网络' },
          { value: '没有网络（自动显示加载）' },
          { value: '没有网络（不自动显示加载）' },
          { value: '未登录' },
          { value: '加载成功' },
        ],
        selected: 0,
        onSelected: (index) => {
          switch (index) {
            case 0:
              this.controller.loading()
              break
            case 1:
              this.controller.empty()
              break
            case 2:
              this.controller.empty({
                emptyStr: '我是单例空白文案',
                emptyIcon: $r('app.media.state_empty')
              })
              break
            case 3:
              this.controller.error()
              break
            case 4:
              this.controller.error({
                retryStr: '我是单例错误按钮',
                errorStr: `我是单例错误文案`,
                isCoverRetry: false, //不会覆盖
                retry: () => {
                  promptAction.showToast({ message: '我是单例重试事件' })
                }
              })
              break
            case 5:
              this.controller.error({
                retryStr: '给我重试',
                errorStr: '单例重试事件，后续点击重试，执行覆盖的重试',
                isCoverRetry: true, //覆盖原来的重试，普通的error和netError后，重试时间被覆盖
                retry: () => {
                  promptAction.showToast({ message: '我是覆盖的重试事件' })
                }
              })
              break
            case 6:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试根据全局配置是否自动加载中）',
              })
              break
            case 7:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试自动显示加载中）',
                showLoadingWhenRetry: true
              })
              break
            case 8:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试不会自动显示加载中）',
                showLoadingWhenRetry: false
              })
              break
            case 9:
              this.controller.error({
                errorStr: '未登录状态提示，等同于Error',
                retryStr: '立即登录',
                showLoadingWhenRetry: false,
                retry: () => {
                  promptAction.showToast({
                    message: '跳转登录的点击事件'
                  })
                }
              })
              break
            case 10:
              this.controller.content()
              break
          }
        },
        hidesBackButton: true
      })
      Row(){
          StateLayout({
            controller: this.controller,
            retry: () => {
              promptAction.showToast({ message: '我是最初重试事件' })
              this.loading()
            },
          }) {
            Text(`加载成功后的内容:::${this.message}`)
              .fontSize(30)
              .fontColor(Color.Black)
              .onClick(() => {
                router.pushUrl({
                  url: "pages/StateLayoutPage"
                })
              })
          }
      }
    }
    .height('100%')
      .width('100%')
  }
}
```
## Feature
目前感觉网络错误的状态和错误状态雷同，无非就是换了文案和图标，打算给他去掉

## 约束与限制

在下述版本验证通过：
DevEco Studio NEXT Release  (5.0.3.900), SDK: API12(5.0.0) 设备：Mate 60 Pro（Release）

## FAQ
- 目前只是简单的设置，细节问题和更多功能正在研究和发掘开发，欢迎提交PR，共同进步

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://github.com/ChawLoo/StateLayout/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://github.com/ChawLoo/StateLayout/pulls) 。

## 开源协议

本项目基于 [Apache-2.0](https://github.com/ChawLoo/StateLayout/blob/master/library/LICENSE) ，请自由地享受和参与开源。
