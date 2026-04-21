@Entry
@Component
struct CocoBakeryDraw {
  // ============ 核心游戏数据 全部补全声明 ============
  @State cocoPowder: number = 100
  @State drawChance: number = 3

  @State flour: number = 0
  @State egg: number = 0
  @State chocolate: number = 0

  readonly costExchange: number = 10
  readonly needFlour: number = 5
  readonly needEgg: number = 3
  readonly needChoco: number = 8

  // 抽奖临时奖励 补全类型声明
  @State isDrawing: boolean = false
  @State showResultPopup: boolean = false
  @State resultText: string = ""
  @State getFlour: number = 0
  @State getEgg: number = 0
  @State getChoco: number = 0

  build() {
    Stack() {
      // 1.全局背景 修正API错误
      Column()
        .width('100%')
        .height('100%')
        .backgroundImage($r('app.media.coco_main_bg'))
        .backgroundImageSize(ImageSize.Cover)


      // 2.上层UI布局
      Column() {

        Blank().layoutWeight(1.2)

        // 道具展示区
        Row({space:40}) {
          Column() {
            Text(`面粉`)
              .fontSize(16)
              .fontColor('#5A381E')
            Text(`×${this.flour}`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#8B4513')
          }

          Column() {
            Text(`鸡蛋`)
              .fontSize(16)
              .fontColor('#5A381E')
            Text(`×${this.egg}`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#8B4513')
          }

          Column() {
            Text(`巧克力`)
              .fontSize(16)
              .fontColor('#5A381E')
            Text(`×${this.chocolate}`)
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .fontColor('#8B4513')
          }
        }
        .padding(20)
        .backgroundColor('rgba(255,255,255,0.75)')
        .borderRadius(18)


        Blank().layoutWeight(1)

        Text(`剩余摇一摇机会：${this.drawChance}次`)
          .fontSize(17)
          .margin({bottom:15})
          .fontColor('#442c1a')

        // 底部双按钮
        Row({space:15}) {
          Button(this.isDrawing ? "抽奖摇动中..." : "摇一摇 得碎片")
            .width('65%')
            .height(70)
            .fontSize(22)
            .borderRadius(35)
            .backgroundColor('#7A482B')
            .fontColor('#fff')
            .enabled(!this.isDrawing && this.drawChance > 0)
            .onClick(()=>{
              this.startDraw()
            })

          Button("兑换\n机会")
            .width('30%')
            .height(70)
            .fontSize(17)
            .borderRadius(20)
            .backgroundColor('#9B5E38')
            .fontColor('#fff')
            .onClick(()=>{
              this.exchangeChance()
            })
        }

        Text(`当前可可粉：${this.cocoPowder}  | 兑换1次消耗${this.costExchange}可可粉`)
          .fontSize(14)
          .margin({top:12, bottom:8})
          .opacity(0.8)

        Button(`🎁 兑换专属礼物 (${this.needFlour}面粉+${this.needEgg}鸡蛋+${this.needChoco}巧克力)`)
          .width('90%')
          .height(55)
          .borderRadius(28)
          .backgroundColor('#633c26')
          .fontColor('#fff')
          .margin({bottom:40})
          .onClick(()=>{
            this.exchangeGift()
          })

      }
      .width('100%')
      .height('100%')
      .padding({left:15, right:15})


      // 抽奖弹窗
      if(this.showResultPopup) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0,0,0,0.55)')

        Column({space:25}) {
          Text(this.resultText)
            .fontSize(26)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .fontColor('#5A381E')

          Row({space:25}) {
            if(this.getFlour>0) {
              Column(){Text("🫓面粉").fontSize(20);Text(`+${this.getFlour}`)}
            }
            if(this.getEgg>0) {
              Column(){Text("🥚鸡蛋").fontSize(20);Text(`+${this.getEgg}`)}
            }
            if(this.getChoco>0) {
              Column(){Text("🍫巧克力").fontSize(20);Text(`+${this.getChoco}`)}
            }
          }

          Button("开心收下")
            .width(200)
            .height(55)
            .borderRadius(30)
            .backgroundColor('#9B5E38')
            .fontColor('#fff')
            .onClick(()=>{
              this.closePopup()
            })
        }
        .width('82%')
        .padding({top:35,bottom:35,left:35,right:35})
        .backgroundColor('#fff9f2')
        .borderRadius(25)
        .shadow({radius:20})
      }

    }
    .width('100%')
    .height('100%')
  }

  // 兑换机会
  exchangeChance(){
    if(this.cocoPowder >= this.costExchange){
      this.cocoPowder -= this.costExchange
      this.drawChance += 1
      AlertDialog.show({message:"兑换成功！获得1次摇一摇机会✨"})
    }else{
      AlertDialog.show({message:"可可粉不足，无法兑换！"})
    }
  }

  // 抽奖逻辑
  startDraw(){
    if(this.drawChance <=0 || this.isDrawing) return
    this.isDrawing = true
    this.drawChance -= 1

    this.getFlour = 0
    this.getEgg = 0
    this.getChoco = 0

    let random = Math.random()
    if(random < 0.25){
      this.resultText = "不要放弃，再摇一次\n说不定有新碎片~"
    }else if(random < 0.5){
      this.getFlour =1
      this.resultText = "✨找到碎片啦！"
    }else if(random < 0.75){
      this.getFlour =1
      this.getEgg =1
      this.resultText = "✨找到碎片啦！"
    }else if(random < 0.92){
      this.getFlour =1
      this.getChoco =1
      this.resultText = "✨找到碎片啦！"
    }else{
      this.getFlour =1
      this.getEgg =1
      this.getChoco =1
      this.resultText = "🎉大丰收！全部碎片到手！"
    }

    setTimeout(()=>{
      this.flour += this.getFlour
      this.egg += this.getEgg
      this.chocolate += this.getChoco
      this.isDrawing = false
      this.showResultPopup = true
    },2200)
  }

  closePopup(){
    this.showResultPopup = false
  }

  // 礼物兑换
  exchangeGift(){
    if(this.flour >= this.needFlour && this.egg >= this.needEgg && this.chocolate >= this.needChoco){
      this.flour -= this.needFlour
      this.egg -= this.needEgg
      this.chocolate -= this.needChoco
      AlertDialog.show({message:"🎁 恭喜！成功兑换限定小礼物！"})
    }else{
      AlertDialog.show({message:"材料不足，继续收集碎片再来兑换吧~"})
    }
  }
}