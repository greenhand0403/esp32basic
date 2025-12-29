# Arduino ESP32 中文说明书 草稿

P66
IO16 开漏输出，不用额外接限流电阻

P68
使用IO17控制三极管，推挽输出可以，开漏输出不行

P71
将LEDC转化为 analogwrite 输出PWM

**P87**
**需要两个100Ω电阻**

P91
需要200欧给LCD供电，其中分出100欧支路，给喇叭和白炽灯供电

**P96**
分压计算测量电压的问题
同时使用其他支路，如测电阻、驱动喇叭时，LCD驱动建议200欧分压后再供电，用100欧不稳定。如果只驱动LCD，可以直接用100欧姆。

**后续电流表的测量范围500mA**

P103
灯柱电源加100欧姆限流，才能与LCD同时亮

P116
灯柱电源需要加100欧姆限流

P122
灯柱信号需要用5.1k上拉，不然会闪烁抖动

#### 构建方法（在book目录下）

```shell

pandoc.exe -s 001-020/*.md 021-040/*.md 041-060/*.md 061-080/*.md 081-100/*.md 101-120/*.md 121-138/*.md -o Arduino-ESP32-Manual.pdf --from markdown --pdf-engine=xelatex --include-in-header=header.tex --resource-path=".;001-020;021-040;041-060;061-080;081-100;101-120;121-138" --toc --toc-depth=2 -V mainfont="Microsoft YaHei" -V CJKmainfont="Microsoft YaHei" -V monofont="Consolas" -V geometry:margin=20mm

```

主要改动的页数：1-3,8,20,22-23,30-36

33 16 17是可以配置成开漏输出的

示意图、流程图P37 P39

#### changelog

P85 电路搭建图错了，图中用的是光敏电阻，正确的应该是用麦克风