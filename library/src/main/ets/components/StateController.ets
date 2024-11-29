import StateConfig, { EmptyConfig, ErrorConfig, LoadingConfig, NetworkErrorConfig } from './StateConfig';
import { StateEnum } from './StateEnum';

@ObservedV2
export class StateController {
  loadingEvent?: (config?: LoadingConfig) => void
  @Trace state: StateEnum = StateConfig.globalStateConfig.defaultState

  loading(config?: LoadingConfig) {
    if (this.loadingEvent) {
      this.loadingEvent(config)
    }
  }

  emptyEvent?: (config?: EmptyConfig) => void

  empty(config?: EmptyConfig) {
    if (this.emptyEvent) {
      this.emptyEvent(config)
    }
  }

  errorEvent?: (config?: ErrorConfig) => void

  error(config?: ErrorConfig) {
    if (this.errorEvent) {
      this.errorEvent(config)
    }
  }

  networkErrorEvent?: (config?: NetworkErrorConfig) => void

  networkError(config?: NetworkErrorConfig) {
    if (this.networkErrorEvent) {
      this.networkErrorEvent(config)
    }
  }

  contentEvent = () => {
  }

  content() {
    this.contentEvent()
  }
}