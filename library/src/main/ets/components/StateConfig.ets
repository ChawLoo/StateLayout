import { StateEnum } from './StateEnum'

export default class StateConfig {
  static globalStateConfig: StateConfig = new StateConfig()
  defaultState: StateEnum = StateEnum.CONTENT
  loadingStr: string = '加载中...'
  progressColor: ResourceColor = '#FF3369E7'
  emptyStr: string = '暂无数据'
  emptyIcon: Resource = $r('app.media.ic_state_empty')
  errorStr: string = '加载失败'
  errorIcon: Resource = $r('app.media.ic_state_error')
  networkErrorStr: string = '网络不稳定，请重试'
  networkErrorIcon: Resource = $r('app.media.ic_state_network')
  retryStr: string = '重新加载'

  constructor() {
    if (StateConfig.globalStateConfig) {
      this.loadingStr = StateConfig.globalStateConfig.loadingStr
      this.progressColor = StateConfig.globalStateConfig.progressColor
      this.emptyStr = StateConfig.globalStateConfig.emptyStr
      this.emptyIcon = StateConfig.globalStateConfig.emptyIcon
      this.errorStr = StateConfig.globalStateConfig.errorStr
      this.errorIcon = StateConfig.globalStateConfig.errorIcon
      this.networkErrorStr = StateConfig.globalStateConfig.networkErrorStr
      this.networkErrorIcon = StateConfig.globalStateConfig.networkErrorIcon
      this.retryStr = StateConfig.globalStateConfig.retryStr
    }
  }
}

export declare interface LoadingConfig {
  loadingStr?: string
  progressColor?: ResourceColor
}

export declare interface EmptyConfig {
  emptyStr?: string
  emptyIcon?: Resource
}

export declare interface ErrorConfig {
  errorStr?: string
  errorIcon?: Resource
  retryStr?: string
}

export declare interface NetworkErrorConfig {
  networkErrorStr?: string
  networkErrorIcon?: Resource
  retryStr?: string
}