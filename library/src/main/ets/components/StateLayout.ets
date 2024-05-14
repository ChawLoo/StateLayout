import StateConfig, { EmptyConfig, ErrorConfig, LoadingConfig, NetworkErrorConfig } from './StateConfig'
import { StateEnum } from './StateEnum'
import StateController from './StateController'
import { isNotBlank } from './Util'

@Builder
function NothingBuilder() {
}

@Component
export default struct StateLayout {
  @State state: StateEnum = StateConfig.globalStateConfig.defaultState
  @State localConfig: StateConfig = new StateConfig()
  @State loadingStr: string = this.localConfig.loadingStr
  @State progressColor: ResourceColor = this.localConfig.progressColor
  @State emptyStr: string = this.localConfig.emptyStr
  @State emptyIcon: Resource = this.localConfig.emptyIcon
  @State errorStr: string = this.localConfig.errorStr
  @State errorIcon: Resource = this.localConfig.errorIcon
  @State retryStr: string = this.localConfig.retryStr
  @State networkErrorStr: string = this.localConfig.networkErrorStr
  @State networkErrorIcon: Resource = this.localConfig.networkErrorIcon
  @BuilderParam public contentBuilder: () => void = NothingBuilder
  retry: () => void = () => {
  }
  controller: StateController = new StateController();

  aboutToAppear(): void {
    if (this.controller) {
      this.controller.loading = this.loading
      this.controller.empty = this.empty
      this.controller.error = this.error
      this.controller.networkError = this.networkError
      this.controller.content = this.content
    }
  }

  private loading = (config?: LoadingConfig) => {
    if (config?.loadingStr) {
      this.loadingStr = isNotBlank(config.loadingStr) ? config.loadingStr : this.localConfig.loadingStr
    }
    this.state = StateEnum.LOADING
  }
  private empty = (config?: EmptyConfig) => {
    if (config?.emptyStr) {
      this.emptyStr = isNotBlank(config?.emptyStr) ? config?.emptyStr : this.localConfig.emptyStr
    } else {
      this.emptyStr = this.localConfig.emptyStr
    }
    if (config?.emptyIcon) {
      this.emptyIcon = config?.emptyIcon ?? this.localConfig.emptyIcon
    } else {
      this.emptyIcon = this.localConfig.emptyIcon
    }
    this.state = StateEnum.EMPTY
  }
  private error = (config?: ErrorConfig) => {
    if (config?.errorStr) {
      this.errorStr = isNotBlank(config?.errorStr) ? config?.errorStr : this.localConfig.errorStr
    } else {
      this.errorStr = this.localConfig.errorStr
    }
    if (config?.errorIcon) {
      this.errorIcon = config?.errorIcon ?? this.localConfig.errorIcon
    } else {
      this.errorIcon = this.localConfig.errorIcon
    }
    if (config?.retryStr) {
      this.retryStr = isNotBlank(config?.retryStr) ? config?.retryStr : this.localConfig.retryStr
    } else {
      this.retryStr = this.localConfig.retryStr
    }
    this.state = StateEnum.ERROR
  }
  private networkError = (config?: NetworkErrorConfig) => {
    if (config?.networkErrorStr) {
      this.networkErrorStr = isNotBlank(config?.networkErrorStr) ? config?.networkErrorStr : this.localConfig.networkErrorStr
    } else {
      this.networkErrorStr = this.localConfig.networkErrorStr
    }
    if (config?.networkErrorIcon) {
      this.networkErrorIcon = config?.networkErrorIcon ?? this.localConfig.networkErrorIcon
    } else {
      this.networkErrorIcon = this.localConfig.networkErrorIcon
    }
    if (config?.retryStr) {
      this.retryStr = isNotBlank(config?.retryStr) ? config?.retryStr : this.localConfig.retryStr
    } else {
      this.retryStr = this.localConfig.retryStr
    }
    this.state = StateEnum.NETWORK_ERROR
  }
  private content = () => {
    this.state = StateEnum.CONTENT
  }

  build() {
    Column() {
      if (this.state == StateEnum.LOADING) {
        this.DefaultLoadingBuilder()
      } else if (this.state == StateEnum.EMPTY) {
        this.DefaultEmptyBuilder()
      } else if (this.state == StateEnum.ERROR) {
        this.DefaultErrorBuilder()
      } else if (this.state == StateEnum.NETWORK_ERROR) {
        this.DefaultNetworkErrorBuilder()
      } else {
        this.contentBuilder()
      }
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
  }

  @Builder
  DefaultLoadingBuilder() {
    LoadingProgress()
      .color(this.progressColor)
      .size({ width: 64 })
    Text(this.loadingStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
  }

  @Builder
  DefaultEmptyBuilder() {
    Image(this.emptyIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.emptyStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
  }

  @Builder
  DefaultErrorBuilder() {
    Image(this.errorIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.errorStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
    Text(this.retryStr)
      .fontSize(16)
      .fontColor(0xFF3369E7)
      .margin({ top: 10 })
      .onClick(() => {
        if (this.state == StateEnum.ERROR) {
          this.state = StateEnum.LOADING
        }
        this.retry()
      })
  }

  @Builder
  DefaultNetworkErrorBuilder() {
    Image(this.networkErrorIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.networkErrorStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
    Text(this.retryStr)
      .fontSize(16)
      .fontColor(0xFF3369E7)
      .margin({ top: 10 })
      .onClick(() => {
        this.retry()
      })
  }
}