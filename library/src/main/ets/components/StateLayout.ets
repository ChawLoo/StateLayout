import StateConfig, { EmptyConfig, ErrorConfig, LoadingConfig, NetworkErrorConfig } from './StateConfig'
import { StateEnum } from './StateEnum'
import StateController from './StateController'
import { isNotBlank } from './Util'

@Builder
function NothingBuilder() {
}

@Component
export default struct StateLayout {
  showLoadingWhenRetry: boolean = StateConfig.globalStateConfig.showLoadingWhenRetry
  @State state: StateEnum = StateConfig.globalStateConfig.defaultState
  @State private loadingStr: string = StateConfig.globalStateConfig.loadingStr
  @State private progressColor: ResourceColor = StateConfig.globalStateConfig.progressColor
  @State private emptyStr: string = StateConfig.globalStateConfig.emptyStr
  @State private emptyIcon: Resource = StateConfig.globalStateConfig.emptyIcon
  @State private errorStr: string = StateConfig.globalStateConfig.errorStr
  @State private errorIcon: Resource = StateConfig.globalStateConfig.errorIcon
  @State private retryStr: string = StateConfig.globalStateConfig.retryStr
  @State private networkErrorStr: string = StateConfig.globalStateConfig.networkErrorStr
  @State private networkErrorIcon: Resource = StateConfig.globalStateConfig.networkErrorIcon
  priorityRetry?: () => void // 优先加载，用于单次传入的retry
  retry?: () => void
  controller: StateController = new StateController();
  @BuilderParam public contentBuilder: () => void = NothingBuilder

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
      this.loadingStr = isNotBlank(config.loadingStr) ? config.loadingStr : StateConfig.globalStateConfig.loadingStr
    }
    this.state = StateEnum.LOADING
  }
  private empty = (config?: EmptyConfig) => {
    if (config?.emptyStr) {
      this.emptyStr = isNotBlank(config?.emptyStr) ? config?.emptyStr : StateConfig.globalStateConfig.emptyStr
    } else {
      this.emptyStr = StateConfig.globalStateConfig.emptyStr
    }
    if (config?.emptyIcon) {
      this.emptyIcon = config?.emptyIcon ?? StateConfig.globalStateConfig.emptyIcon
    } else {
      this.emptyIcon = StateConfig.globalStateConfig.emptyIcon
    }
    this.state = StateEnum.EMPTY
  }
  private error = (config?: ErrorConfig) => {
    if (config?.errorStr) {
      this.errorStr = isNotBlank(config?.errorStr) ? config?.errorStr : StateConfig.globalStateConfig.errorStr
    } else {
      this.errorStr = StateConfig.globalStateConfig.errorStr
    }
    if (config?.errorIcon) {
      this.errorIcon = config?.errorIcon ?? StateConfig.globalStateConfig.errorIcon
    } else {
      this.errorIcon = StateConfig.globalStateConfig.errorIcon
    }
    if (config?.retryStr) {
      this.retryStr = isNotBlank(config?.retryStr) ? config?.retryStr : StateConfig.globalStateConfig.retryStr
    } else {
      this.retryStr = StateConfig.globalStateConfig.retryStr
    }
    this.priorityRetry = config?.retry
    if (config?.retry) {
      if (config?.isCoverRetry !== undefined && config.isCoverRetry) {
        this.retry = config.retry
      }
    }
    if (config?.showLoadingWhenRetry !== undefined) {
      this.showLoadingWhenRetry = config.showLoadingWhenRetry
    } else {
      this.showLoadingWhenRetry = StateConfig.globalStateConfig.showLoadingWhenRetry
    }
    this.state = StateEnum.ERROR
  }
  private networkError = (config?: NetworkErrorConfig) => {
    if (config?.networkErrorStr) {
      this.networkErrorStr = isNotBlank(config?.networkErrorStr) ? config?.networkErrorStr : StateConfig.globalStateConfig.networkErrorStr
    } else {
      this.networkErrorStr = StateConfig.globalStateConfig.networkErrorStr
    }
    if (config?.networkErrorIcon) {
      this.networkErrorIcon = config?.networkErrorIcon ?? StateConfig.globalStateConfig.networkErrorIcon
    } else {
      this.networkErrorIcon = StateConfig.globalStateConfig.networkErrorIcon
    }
    if (config?.retryStr) {
      this.retryStr = isNotBlank(config?.retryStr) ? config?.retryStr : StateConfig.globalStateConfig.retryStr
    } else {
      this.retryStr = StateConfig.globalStateConfig.retryStr
    }
    this.priorityRetry = config?.retry
    if (config?.retry) {
      if (config?.isCoverRetry !== undefined && config.isCoverRetry) {
        this.retry = config.retry
      }
    }
    if (config?.showLoadingWhenRetry !== undefined) {
      this.showLoadingWhenRetry = config.showLoadingWhenRetry
    } else {
      this.showLoadingWhenRetry = StateConfig.globalStateConfig.showLoadingWhenRetry
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
        if (this.showLoadingWhenRetry && this.state != StateEnum.LOADING) {
          this.state = StateEnum.LOADING
        }
        if (this.priorityRetry) {
          this.priorityRetry()
        } else {
          if (this.retry) {
            this.retry()
          }
        }
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
        if (this.showLoadingWhenRetry && this.state != StateEnum.LOADING) {
          this.state = StateEnum.LOADING
        }
        if (this.priorityRetry) {
          this.priorityRetry()
        } else {
          if (this.retry) {
            this.retry()
          }
        }
      })
  }
}