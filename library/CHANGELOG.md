# Changelog

## [V2.2.1] 2024.11

- 优化页面展示效果，移除StateLayout最外层的宽高100%，使其本身自适应高度，除了content的缺省页均最小高度并居中，根据状态动态化切换居中和垂直Start
- ⚠️⚠️建议StateLayout外包一层Row，因为使用了alignSelf动态化切换Center和Start，感觉没啥更好的处理方式了，要么宽高100%，然后其父组件写死高度，否则一样会被撑开
- 如有更好的方案，欢迎提[PR](https://github.com/ChawLoo/StateLayout/pulls)
- 详情可以看源码

## [V2.2.0] 2024.11

- 优化页面效果，详情可以直接打开代码，没有混淆，展示效果可以看demo，拉下来跑一下就行
- 每一个缺省状态外层包裹Column并且居中
- 内容Builder也包裹，撑满但从上面开始
- 以上优化改善界面布局，一句话概括：整个StateLayout撑满布局，大小由他爹控制
- feature：刷新组件，结合状态组件正在试点中，敬请期待

## [V2.1.0] 2024.10

- 新增功能不升级该版本不影响使用 https://github.com/ChawLoo/StateLayout/issues/2
- 新增全局Builder去配置缺省页(⚠️⚠️注意全局Builder有一定的局限性)
- 如有需要，可以增加一个json字符串，在对应Builder中解析获取
- 目前仅更新V2版本功能，如需请提issue，或者提PR

## [V2.0.3-alpha.1] 2024.10

- 先行版本，该版本会让整个导包需要替换一下，纠结的可以不升级
- 修改导出逻辑，减少引入处的代码
- 例如：import StateLayout from '@chawloo/state-layout/src/main/ets/components/StateLayout'[旧版]
- 改为：import { StateLayout } from '@chawloo/state-layout'【新版】

## [V2.0.2] 2024.07

- 最新版的DevEco对V2的校验，更加严格，对外方法都必须加@Event，外部传入的必须加@Param等

## [V2.0.1] 2024.07

- 针对V2版本暴露State，因为State修饰的@Param不支持组件内部修改，所以只能另起变量，然后通过@Monitor关联

## [V2.0.0] 2024.07

- 全面升级api12，不兼容老版本，@Component 升级为@ComponentV2,都用了V2版本，V1版本还是用V1.2.2吧
- 会拉新分支，如果V1.2.2有问题会继续更新V1.2.3类推

## [V1.2.2] 2024.07

- 放开原来的方案，将所有属性改为@Prop，可以外部@State传入进行修改，这样就全部手动了，用于解决绘制时序问题。https://github.com/ChawLoo/StateLayout/issues/1
- 两种方案都支持，但是手动方案没有自动方案来的舒畅和全面。
- 求点在Like，跪谢

## [V1.2.1] 2024.05

- 由于本人知道你们懒（其实我自己懒）
- 所以StateController新增了缺省页对应的方法，并并把原来的方法加了后缀Event
- 这样输入的时候不需要输入括号了，而且不影响原来的，是不是很棒？
- 求点赞Like，跪谢

## [V1.2.0] 2024.05

- 新增重试添加是否自动显示加载中开关
- 新增错误和网络错误可单独设置Retry方法，用于适应特殊场景（如：未登录缺省页,VIP权限缺省页）
- 新增单例重试事件的覆盖开关，自主选择是否覆盖

## [V1.1.1] 2024.05

- 修改仓库地址为github
- 新增example目录

## [V1.1.0] 2024.05

- 传新版本，重要升级，推翻了原有的设计，请重新仔细阅读README.md，该版本更简便
- 夏天到了，原来的`StateLayoutComponent`太长了，所以我们名字减个肥，改成`StateLayout`
- 暴露`GlobalStateConfig`静态变量，修改全局默认属性值
- 采用全新的切换缺省页方法 - `StateController`，支持单次配置

## [v1.0.0] 2024.05

- 发布1.0.0版本，实现简单缺省页变更和全局设置
