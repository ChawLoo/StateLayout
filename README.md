# StateLayout

## 简介

[StateLayout](https://github.com/ChawLoo/StateLayout.git) ，是一个针对HarmonyOS Next系统开发的沉浸式框架，采用官方底层API，简单、实用、高效。

- 根据状态显示对应状态页面
- 可以全局配置状态页样式

## 下载安装

```
ohpm install @chawloo/state-layout
```

OpenHarmony ohpm 环境配置等更多内容，请参考[如何安装 OpenHarmony ohpm 包](https://gitee.com/openharmony-tpc/docs/blob/master/OpenHarmony_har_usage.md)

## 接口和属性列表
### `StateConfig`属性列表

| 属性               | 类型            | 描述          |
|:-----------------|:--------------|:------------|
| loadingStr       | string        | 加载缺省页提示文本   |
| progressColor    | ResourceColor | 加载缺省页进度条颜色  |
| emptyStr         | string        | 空白缺省页提示文本   |
| emptyIcon        | string        | 空白缺省页图标     |
| errorStr         | string        | 错误缺省页提示文本   |
| errorIcon        | Resource      | 错误缺省页图标     |
| networkErrorStr  | string        | 网络错误缺省页提示文本 |
| networkErrorIcon | Resource      | 网络错误缺省页图标   |
| retryStr         | string        | 重试按钮文本      |

### 全局配置`globalStateConfig`配置接口

| 接口                                   | 描述                    |
|:-------------------------------------|:----------------------|
| loadingConfig(LoadingConfig)         | 配置加载中的提示文案和Progress颜色 |
| emptyConfig(EmptyConfig)             | 配置空白页的提示文案和图标         |
| errorConfig(ErrorConfig)             | 配置错误中的提示文案、图标和重试文本    |
| networkErrConfig(NetworkErrorConfig) | 配置网络错误中的提示文案、图标和重试文本  |

## 全局配置
可在任意地方配置，推荐`EntryAbility`中配置
```typescript
//在windowStageCreate中配置即可
onWindowStageCreate(windowStage: window.WindowStage): void {
  //全局配置缺省页的各种图标和文案
  StateConfig.globalStateConfig = new StateConfig()
    .loadingConfig({
      progressColor: Color.Red
    })
    .emptyConfig({
      emptyStr: '我是全局配置的空白提示文案',
      emptyIcon: $r('app.media.state_empty')
    })
  //也可以直接调用属性配置
  StateConfig.globalStateConfig.retryStr = "立即重试"
  });
}
```
## 使用

#### 简单用法
```typescript
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State config: StateConfig = new StateConfig()
  @State state: StateEnum = StateEnum.LOADING

  aboutToAppear(): void {
    this.loading()
  }

  //模拟网络加载
  loading() {
    const timerId = setInterval(() => {
      //简单设置状态
      this.state = StateEnum.CONTENT
      clearInterval(timerId)
    }, 2000)
  }

  build() {
    Column() {
      //添加缺省页组件
      StateLayoutComponent({
        state: this.state,
        stateConfig: this.config,
        retry: () => {

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
    .height('100%')
    .width('100%')
  }
}
```

#### 进阶用法

通过`StateEventDispatcher`来发送消息给子组件进行状态切换，StateLayoutComponent需要接受一个EventID来区分来自哪个界面

| 方法             | 说明           |
|:---------------|:-------------|
| 构造方法           | 内部初始化EventID |
| loading()      | 展示加载中页面      |
| empty()        | 展示空白页面       |
| error()        | 展示错误页面       |
| content()      | 展示错误页面       |
| networkError() | 展示网络错误页面     |


```typescript
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State config: StateConfig = new StateConfig()
  @State state: StateEnum = StateEnum.LOADING
  stateEvent = new StateEventDispatcher()

  aboutToAppear(): void {
    this.loading()
  }

  //模拟网络加载
  loading() {
    const timerId = setInterval(() => {
      this.state = StateEnum.CONTENT
      clearInterval(timerId)
    }, 2000)
  }

  build() {
    Column() {
      SelectTitleBar({
        options: [
          { value: '加载中' },
          { value: '空白页' },
          { value: '错误页' },
          { value: '没有网络' },
          { value: '加载成功' },
        ],
        selected: 0,
        onSelected: (index) => {
          switch (index) {
            case 0:
              this.state = StateEnum.LOADING
              break
            case 1:
              this.config.emptyStr = '不一样的空白页文案' //修改后当前页面就一直是这个，除非再次修改
              this.config.emptyIcon = $r('app.media.state_empty') //修改后当前页面就一直是这个，除非再次修改
              this.stateEvent.empty()
              break
            case 2:
              this.config.retryStr = '给我重试' //修改后当前页面就一直是这个，除非再次修改
              this.stateEvent.error()
              break
            case 3:
              this.stateEvent.networkError()
              break
            case 4:
              this.stateEvent.content()
              break
          }
        },
        hidesBackButton: false
      })
      StateLayoutComponent({
        state: this.state,
        stateConfig: this.config,
        retry: () => {

        },
        eventID: this.stateEvent.eventID
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
    .height('100%')
    .width('100%')
  }
}
```

## Feature

整理调用方法来实现状态页切换同时，传入单次文案和图标。

## 约束与限制

在下述版本验证通过：
DevEco Studio NEXT Developer Beta1  (5.0.3.200), SDK: API11(4.1.0) 设备：Mate 60 Pro（Preview2）

## FAQ
- 目前只是简单的设置，细节问题和更多功能正在研究和发掘开发，欢迎提交PR，共同进步

## 贡献代码

使用过程中发现任何问题都可以提[Issue](https://github.com/ChawLoo/StateLayout/issues) 给我们，当然，我们也非常欢迎你给我们提[PR](https://github.com/ChawLoo/StateLayout/pulls) 。

## 开源协议

本项目基于 [Apache-2.0](https://gitee.com/chawloo_organization/StateLayout/blob/master/library/LICENSE) ，请自由地享受和参与开源。