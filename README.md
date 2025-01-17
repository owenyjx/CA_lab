Computer Architecture 2020 Lab
=====================

**此仓库用于发布USTC体系结构课程2020年夏季学期的实验代码和要求，同时可用于学生的意见反馈。**  
实验成绩占课程成绩的40%，实验验收方式主要为课堂当面验收和实验报告的提交。  
本学期计划实验时长为10周  

* Lab1（第4-5周）  【15%】： 熟悉RISC-V指令集，完成RV32I指令集流水线CPU的设计报告；
* Lab2（第6-8周）  【40%】： 完成RV32I流水线CPU的Verilog代码；利用RISCV-test测试文件进行仿真和CPU功能验证
* Lab3（第9-10周） 【20%】： cache设计和实现

-----------------------------------（五一假期推迟一周）---------------------------------------------------

* Lab4（第12-13周）【15%】： 分支预测设计与实现
* Lab5（第14周）   【10%】： 学习使用提供的Tomasulo软件模拟器和多Cache一致性软件模拟器，并完成实验报告


## 签到与补交

* 目前大家无法返校，需要验收的实验**推迟到返校后验收**，相应的实验报告也推迟提交。具体要求另行通知。
* **验收推迟并不影响实验布置**。返校后很快会验收实验和提交报告。请大家合理安排时间完成。
* 验收和报告**补交**在**一周内扣除20%成绩**，介于**一周两周之内补交扣除40%成绩**，**超过两周不予验收**。

## 助教统一讲解

* 返校前大家可以参考提供的实验文档，如果有疑惑，可以在课程QQ群，或者仓库提Issue询问助教。


## 实验资源


* 实验教学中心提供了一个基于互联网的远程进行硬件、系统和软件 7x24 教学实验的平台，可校外登录使用，支持 SSH、浏览器和 VNC 远程桌面的方式来使用（方便 Windows 用户使用 Linux）。这个平台可以通过虚拟机的方式来进行软件和系统方面的实验（基于 Linux 容器的方式使得线上体验和线下机房一致），还能够远程操作已部署好的 FPGA 集群进行硬件实验。
平台集群基于 Linux 容器搭建，计算与存储分离，提供给学生 7x24 小时使用。架构方面和 Linux 容器部署使用方面的稳定性已经经过多年验证。系统架构方面的瓶颈仅受限于网络带宽。
这套系统基于 Linux 容器来支持各类系统和软件的虚拟化及远程使用。现有容量支持 300 名以上的轻度使用用户同时在线使用，支持 150 名左右的中度使用用户同时在线，支持 90 名左右的重度使用用户（计算密集型）同时在线。
使用说明：[https://vlab.ustc.edu.cn/docs/vm/](https://vlab.ustc.edu.cn/docs/vm/)，平台地址：[https://vlab.ustc.edu.cn/](https://vlab.ustc.edu.cn/)。欢迎大家试用

* 课程实验用到的语言是system verilog(sv, verilog的超集)，所以理论上支持sv并且能仿真的IDE都可以用来做实验，但推荐使用vivado工具(ise 也可)，这里给出vivado的下载链接。链接：[https://vlab.ustc.edu.cn/docs/downloads/](https://vlab.ustc.edu.cn/docs/downloads/)


## 实验发布、验收和报告

* **2020.3.9 Release Lab1**  
  请提交CPU设计报告 截止日期：2020.3.23  
  提交至BB平台  
  提交格式：**Lab1-学号-姓名-n.rar(or .zip)**。要求包括一份**pdf格式**实验报告（如果无法打开会影响最终成绩）  
  提交版本号，从0开始，以最大版本提交文件为准  

* **2020.3.23 Release Lab2**  
  请完成实验，并在检查后一周内提交实验报告 截止日期：返校后（待定）
  实验报告提交至BB平台  
  提交格式：**Lab2-学号-姓名-n.rar(or .zip)**。要求包括一份**pdf格式**实验报告（如果无法打开会影响最终成绩）  
  提交版本号，从0开始，以最大版本提交文件为准  


## 实验课安排

* 返校后另行通知，请大家持续关注。

## 文件夹目录

**Lab1** （实验一代码仓库）

**Lab2** （实验二代码仓库）

**Design Figure** （RV32I Core设计图）

**Reference** （实验参考文档）




## Quickstart

* 新实验发布时会在群里面统一公告。  
* 动手做新实验时，请先进入**相应实验目录**下，**查找本次实验对应的文档，并根据文档完成实验和试验报告。**  

## Change Log

* 2020.3.9 发布实验一
* 2020.3.15 修正了Design Figure的PCE + 4问题（原图计算jarl和jal的链接地址，使用的是PC+8）
* 2020.3.23 发布实验二，修正了Design Figure的一些问题。大家请根据最新的Design Figure完成实验（新的Design Figure不影响实验一评分）
* 2020.3.26 修正了实验二的一些问题。大家请根据最新的代码框架完成实验


## 致谢

现在是2020年春季学期学期初，体系结构课程实验正在进行它的升级换代。

感谢嵌入式系统实验室研二的同学们，本学期的实验是在他们设计的2019年CA实验基础上完成的。由于时间和能力有限，实验过程中可能存在一些问题，希望大家多多体谅，也欢迎大家在群里或者issue中提出宝贵的意见。

感谢ESLAB的同学们为本实验付出的努力，也感谢每一位参与实验的本科生的理解与支持。
