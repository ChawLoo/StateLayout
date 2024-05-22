import { EmptyConfig, ErrorConfig, LoadingConfig, NetworkErrorConfig } from './StateConfig';

export default class StateController {
  loading = (config?: LoadingConfig) => {
    console.log('显示加载');
  }
  empty = (config?: EmptyConfig) => {
    console.log('显示空白');
  }
  error = (config?: ErrorConfig) => {
    console.log(`显示错误${config}`);
  }
  networkError = (config?: NetworkErrorConfig) => {
    console.log(`显示网络错误${config}`);
  }
  content = () => {
    console.log(`显示内容`);
  }
}