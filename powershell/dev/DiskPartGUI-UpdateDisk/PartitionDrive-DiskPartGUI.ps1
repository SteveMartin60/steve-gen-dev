CLS

#..............................................................................

#..............................................................................
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#..............................................................................
# DiskPart Command-Line Options:   http://technet.microsoft.com/en-us/library/cc766465(v=ws.10).aspx
#..............................................................................
Function do_ViewPartition
{
    $radioOption = $this.Text
    Switch($radioOption)
    {
        "Default BIOS/MBR"
        {
             $MbrSystemLabel.    Visible = $True
             $systemTextbox.     Visible = $True
             $MbrWindowsLabel.   Visible = $True
             $windowsTextbox.    Visible = $True
             
             $MbrRecoveryLabel.  Visible = $False
             $recoveryTextbox.   Visible = $False
                             
             $gptWinRELabel.     Visible = $False
             $gptWinRETextbox.   Visible = $False
             $gptSystemLabel.    Visible = $False
             $systemGPTTextbox.  Visible = $False
             $gptMSRLabel.       Visible = $False
             $gptMSRTextbox.     Visible = $False
             $gptWindowsLabel.   Visible = $False
             $gptWindowsTextbox. Visible = $False
             $gptRecoveryLabel.  Visible = $False
             $gptRecoveryTextbox.Visible = $False

             # DefaultBIOS_MBR
             $partitionPic = [System.Convert]::FromBase64String(
             "/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsK
             CwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQU
             FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCABVAVgDASIA
             AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
             AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
             ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
             p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
             AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
             BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
             U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
             uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD7L/ag
             /arHwQ1DTPDPh/TrbW/GWpQNeeVezNHa2FsG2iafaCzbmyqIuC21jkBa+cpP24vjS8jFH8BIueE/
             s68OP/I9VvjJ4qtPD/8AwUjlk1O/t7G0Sx04fab2RUihH2W427mbgDe2ee7VmReIfCviU6Bp3jzX
             9E13x5aadfyvKmoRNaXBM8f2aCe4jeNGdYzMwHmD+EFugr3cPh6Hs1KpHmvru/P/ACPJrVqqm1CV
             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
             MEVdqDoiqoAVR6AUUUUAf//Z")

             do_InputPicture -File $partitionPic
        }

        "Recommended BIOS/MBR"
        {
             $MbrSystemLabel.    Visible = $True
             $systemTextbox.     Visible = $True
             $MbrWindowsLabel.   Visible = $True
             $windowsTextbox.    Visible = $True
                                 
             $MbrRecoveryLabel.  Visible = $True
             $recoveryTextbox.   Visible = $True
                                 
             $gptWinRELabel.     Visible = $False
             $gptWinRETextbox.   Visible = $False
             $gptSystemLabel.    Visible = $False
             $systemGPTTextbox.  Visible = $False
             $gptMSRLabel.       Visible = $False
             $gptMSRTextbox.     Visible = $False
             $gptWindowsLabel.   Visible = $False
             $gptWindowsTextbox. Visible = $False
             $gptRecoveryLabel.  Visible = $False
             $gptRecoveryTextbox.Visible = $False
             
             # RecommendedBIOS_MBR
             $partitionPic = [System.Convert]::FromBase64String(
             "/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsK
             CwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQU
             FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCABeAVgDASIA
             AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
             AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
             ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
             p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
             AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
             BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
             U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
             uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD7g/aT
             /aWh+BcOk6XpumJr/i7WVlks7CW58iCCGPAe4uHAJWMMyqAoJZjgdCR86t+298ZnZjHo3w+CZ4Be
             +Yj8cjNJ8YruO/8A+Ci2labqEcd5atpumW6wzRh18rF1IVKnggtk478VFqnh7Q/iJ/wjd5GYtRtm
             0i/1M6lo1kum/wBpNFKiCy8qNZCksO4lztJKkYBHNe1h6FDki6qbvr/X3Hl161Xmapu1iUftufGr
             /oD/AA9/O+/+Ko/4bc+NP/QH+Hv533/xVcj4j+F2laHpV2bU67q7Nd3cQ1eKNY7XSUgkjTF4rAEE
             iQk8qRgbVOa1ta+EfhvSRq9zOfEFnb6MmqK9tdSRrLqIs445BcwHZgRPvKnhgMrgmuz6tgez/E5v
             b4rujY/4bc+NP/QH+Hv533/xVH/Dbnxp/wCgP8Pfzvv/AIqszUvg/wCFoNQ1BYLrWkt9Mnu47kST
             Rl5hHpovk2HbhcA7DnOevHSnQ/BzwtrGoww2N9qtmkdxaNKlzOjmeO40571IYyqcSDZs3YO7Odue
             KXsMD2f4j9tiu6/A0T+258ah/wAwf4e/nff/ABVH/DbvxpyB/Y/w9yfe+/8AiqwbX4WeFv7bjsbi
             51zfqOpwaZaxKRG1m81g1z+83xhpNjKB91dykHitPwx8L9IvvC0WmSR39vJqp0B28Q3KqbeT7SXd
             0tTt4YY8sjc2SOcdKHQwS15X+IKtiX1X3Fv/AIbd+NP/AEB/h7+d9/8AFUjftvfGheukfDwf8Cvv
             /iqo+GvhfoVr4ytrhbPXNUiju9IH9iqpaW0+0zSK0k5eJTJCohHOxQfMwSMc53wlu7WbxN8YCti1
             xJpcoFstpoiarJADesh8u2bAPy8cdBz2oeHwfK2ovS3XuCr4i6Tf4G//AMNu/Gn/AKBHw99et9/8
             VSf8NvfGjGf7I+HmPXdff/FVu3nhXRbfXbyBNC06S7XxBevp2n7Aq3Ew0iO4gtnU8jMjbjDnAbK1
             z2gTySWOh674j8GvbeKbjS9Re5ttO0mE3NvBHNEsN9/Zr4Eh+aRNoXJA3Y4zUKjhGrqD+8r2uIWn
             N+BKf23vjSBn+yPh4B67r7/4qkP7b3xoBOdI+Hgx1+a+/wDiqksotN8EfE+Z9a0vSbyG91Ce7+yR
             2flw/ZrfS2uJB5T5MR3zIWT+FlI7CuvtPCOheGL3w1ocWnWt9d2cmrvNcx2KXkkxeyN1APLI/elE
             eIqhPXApSpYWNvce19xqpiH9r8DjD+2/8aAM/wBkfDzHruvv/iqd/wANufGn/oD/AA9/O+/+KrSv
             W0fQJ9Q1q++w+H1ufD2nSm/1Pw4m+3le/MDyzaeeIcjA4P3Ru9q811/Q7DXv2ivE3h59OudKsrK2
             uL1dM08Kkt6YbYOBbgbgBORvXaGwrcA4q6eHwk7+69F3IlWxEbe8vuO3/wCG3fjTjP8AY/w9x9b7
             /wCKpf8Ahtz40/8AQH+Hv533/wAVVPxZ4S8N2F5ouozWWp6ddTXmg6Ra2BESiGSe1jlaS5Uph3HI
             YYG4nmsOP4a6DrX2XUm1yWytNT1weHk3FB5Wo/bHSYFcABBAquoHd1GcVSw+Deri/wAQ9viV1X3H
             Uf8ADbnxq/6A/wAPfzvv/iqP+G2/jV/0B/h7+d9/8VXn+seBdJt/jN4J8Jwz6jZ2XiCVI54LnPn2
             2ZniyrtGm7cEDA7cAkjnGa63Q/gxpGraxpbyWXiC00+6i2XFjdTKl3av9uNqkxCxFmR8FlATHByw
             XmnLDYKNm09fNkqvin1Rp/8ADbfxpx/yB/h7+d9/8VSf8Nu/GnGf7H+HuPXdff8AxVYfh/wZ4T0j
             UYdOvbPVdd1a60HWtQVRKqxg2slxCmyMKWMhMIYdgexrdtPCmiyWlgy2M0mrHVLO3k1BYIjHHE+j
             rcBGi2bMFiRkjJbnJNQ6GDT+F/eWq2Ja3X3B/wANufGr/oD/AA9/O+/+Ko/4bc+NP/QH+Hv533/x
             VYGk/B3RtQh8Pwy3GsW7XL6OZNWJQ2moi+BLx2vy/fixzy2drZA4qTwd8LPC/jObTbi0fW0tdU0y
             Oe1tZZQds5u5rdg86RMq58kMoZVXLEFhiqeHwK1s/vZPtsV3Rt/8NufGr/oD/D3877/4qj/htz40
             /wDQH+Hv533/AMVXy/e+Jnsb25tXkxJBK8TDcDyrEHkcHp24qH/hMP8App+tdv8AZuFfT8TneNr9
             /wAD6m/4bc+NP/QH+Hv533/xVH/Dbnxp/wCgP8Pfzvv/AIqvln/hMP8App+tH/CYf9NP1o/szDdv
             xD69X7/gfU3/AA258af+gP8AD3877/4qj/htz40/9Af4e/nff/FV8s/8Jh/00/Wj/hMP+mn60f2Z
             hu34i+vV+/4H1N/w258af+gP8Pfzvv8A4qj/AIbc+NP/AEB/h7+d9/8AFV8s/wDCYf8ATT9aP+Ew
             /wCmn60f2Zhu34h9er9/wPqb/htz40/9Af4e/nff/FUf8NufGn/oD/D3877/AOKr5Z/4TD/pp+tH
             /CYf9NP1o/szDdvxH9er9/wPqb/htz40/wDQH+Hv533/AMVR/wANufGn/oD/AA9/O+/+Kr5Z/wCE
             w/6afrR/wmH/AE0/Wj+zMN2/EX16v3/A+pv+G3PjT/0B/h7+d9/8VR/w258af+gP8Pfzvv8A4qvl
             n/hMP+mn60f8Jh/00/Wj+zMN2/EPr1fv+B9Tf8NufGn/AKA/w9/O+/8AiqP+G3PjT/0B/h7+d9/8
             VXyz/wAJh/00/Wj/AITD/pp+tH9mYbt+IfXq/f8AA+pv+G3PjT/0B/h7+d9/8VT4P23vjKkqmbQ/
             h/LGOqJLfIT/AMC5x+Rr5W/4TD/pp+tH/CYf9NP1o/szDdvxD69X7/gfqX+zv8f7D49+Gb26WxfR
             df0m4Fnq2jySiU28hUMjo4xvidTuV8DOCCAVIor4t/YB8UXUv7TWtQwSkWl34cjS5iHSRlncxsfd
             RvA9nNFfK4mkqNaVNbI+gozdSmpvqdJ+0z+y74/+PX7VnifUvBGs6NpJ0vRdKSZ9SmnikDubnaYz
             Ep7IcnjrXDWn/BOT4+6f5H2Xxn4VtTBIZYfIvr5PKcjDMuIxtYjgkcmvunwR/wAnF/FH/sFaH/7e
             V6Lr/iLTPCuj3erazqNppOl2ieZcXt9MsMMS+rOxAA+tXDF1qcVCMtCZYelN80lqfmh/w7h+PZtL
             m1/4TLwp9lun824g+23vlzP/AHnXy8Mfc5NOm/4JzfH652ed418LTeXCbZPMv75tsR6xjMfCf7PT
             2r7UP7YvwteV1t9Y1PUEUkefY+H9QnhfHdZEgKsPcEikH7YnwyIUi814hun/ABTGpc/T/R6v69iP
             5vwRH1Wj2Pi0/wDBOb4/EuT418LEuSXzf33zZXac/u+cr8v046U3/h3H8fQyMPGnhUMrpIrfbr7K
             sgwjD93wVHAPYdK+1P8AhsT4ZAE/bNewDgn/AIRjUuD/AOA9L/w2H8M8kfbNeyBkj/hGNS4/8l6P
             r2J/mD6tR7HxW/8AwTl+P0lw07+NfCzztL57TNf3xcyYxvLeXndjjd1xxSH/AIJyfH02kVofGnhU
             2kODHbm+vvLjIO4bV8vA554HXmvtQftifDM7cXmvfN0/4pjUuf8AyXo/4bE+GWM/bNexnGf+EY1L
             r6f8e9H17E/zfgg+rUex8Yf8O7v2g/tk93/wnXhoXdwuya4/tG/8yVePlZtmWHA4J7Uyx/4Jz/H/
             AEu4luLHxt4Xsp5eZJba/vonk5z8zLGCeeea+0j+2J8Mxuzea8NvX/imNS4+v+j0v/DYfwzyB9r1
             7JGQP+EY1Lp/4D0fXsT/ADfgg+rUex8UP/wTf+PTsGbxj4TdhN9oBa9vSfN/56f6v7/+1196mb/g
             nZ+0E+qjVG8c+GW1NeBfHUb8zgYx/rNm7px1r7Q/4bE+GRAIvNeIPAP/AAjGpc/+S9B/bE+GQDH7
             ZrwC9T/wjGpcf+S9H13Ed/wQfVqPY+KZP+CcHx6mk3v4x8KSSZc73vb0nL/6zkx/xfxevfNTRf8A
             BOz9oKGZJo/HPhmOZDuWVNRvwynaFyCEyDtAX6ADpX2j/wANh/DPOPtevZxnH/CMal0/8B6Qftif
             DM7cXmvHd0/4pjUuf/Jej67if5vwQfVaP8p8V3f/AATi+Pd/JPJdeMvCl1JcBVmee+vZDKF+6GJj
             O4DsD0pF/wCCcHx6W8hux4x8Ji7gCiG4F7e+ZGFGFCt5eVwOBg8V9q/8NifDLBP2zXsA4z/wjGpd
             fT/j3pf+Gw/hmCR9s17KjJ/4pjUuP/Jej69if5g+q0f5T4rm/wCCcnx9uGDTeNPCszB1lBkvr5jv
             UYVuY+oHAPUVA/8AwTX+Okkflv4r8INH5hm2NdXhXzD1fHl/eP8Ae619t/8ADYfwzJA+2a9k8gf8
             IxqXI/8AAek/4bE+GRAP2zXsE4B/4RjUuT6f8e9H17Er7QfVaP8AKfHuhfsBftDeH/GGl+KIvGHg
             281rTp0uILjULi8uPmT7u7dHlgPTNVZv+Cef7Qs+oT3x8deGVu512SSrqN+GKZzszszsHZegr7MP
             7YnwyG7N5r3y9f8AimNS4/8AJel/4bD+Gecfa9ezjOP+EY1Lp/4D0vruI3v+CH9Wo9j4rT/gnL8f
             Y7mO5Txp4VS5iDCOZb6+DoGyWAby8gHc2cdcn1pU/wCCdH7QEQcR+NvC8YcqXC6hfDcVGFJ/d84H
             A9BwK+0v+GxPhkQCLzXju6f8UxqXP/kvR/w2L8MgCftmvYBwT/wjGpcH/wAB6f17E/zC+q0f5T4r
             X/gnJ8fVgtYB408KrBaOZLaIX18EgY9WjHl4Q+4xTrT/AIJz/H+wYNa+NvC9qwjMIMF/fIRGTkpx
             GPlJJJHTJNfaf/DYfwzBI+2a9kDJH/CMalx/5L0g/bE+GZ24vNe+bp/xTGpc/wDkvR9dxHf8EH1W
             j2PiAf8ABMv42f8AQx+Cv+/13/8AGqP+HZfxs/6GPwV/3+u//jVfb/8Aw2J8MsZ+2a9jOM/8IxqX
             X0/496U/tifDMbs3mvDb1/4pjUuPr/o9P6/if5vyF9Vofynw/wD8Oy/jZ/0Mfgr/AL/Xf/xqj/h2
             X8bP+hj8Ff8Af67/APjVfcH/AA2H8MyQPtevZIyB/wAIxqXT/wAB6T/hsT4ZEA/bNeIJwP8AimNS
             5/8AJej6/if5vyD6rQ/lPiD/AIdl/Gz/AKGPwV/3+u//AI1R/wAOy/jZ/wBDH4K/7/Xf/wAar7fP
             7YnwyAYm817C9T/wjGpcf+S9L/w2H8M84+169nGcf8IxqXT/AMB6Pr+J/m/IPqtD+U+H/wDh2X8b
             P+hj8Ff9/rv/AONUf8Oy/jZ/0Mfgr/v9d/8Axqvt8ftifDM7cXmvHd0/4pjUuf8AyXo/4bE+GQBP
             2zXsA4z/AMIxqXX0/wCPej6/if5vyD6pQ/lPiD/h2X8bP+hj8Ff9/rv/AONUf8Oy/jZ/0Mfgr/v9
             d/8AxqvuA/th/DMEj7Zr2QMn/imNS4/8l6P+Gw/hmSB9s17J5A/4RjUuR/4D0fX8T/N+QfVKH8p8
             P/8ADsv42f8AQx+Cv+/13/8AGqP+HZfxs/6GPwV/3+u//jVfb/8Aw2J8MsA/bNewTgH/AIRjUuT6
             f8e9B/bE+GQ3ZvNeG3r/AMUxqXH/AJL0fX8T/N+QfVKH8p8Qf8Oy/jZ/0Mfgr/v9d/8Axqj/AIdl
             /Gz/AKGPwV/3+u//AI1X3B/w2H8M92PtevZxnH/CMal0/wDAekH7YnwyIBF5rxDdP+KY1Ln/AMl6
             Pr+J/m/IPqlD+U+IP+HZfxs/6GPwV/3+u/8A41R/w7L+Nn/Qx+Cv+/13/wDGq+3z+2J8MgCTea9g
             HBP/AAjGpcf+S9L/AMNh/DPJH2vXsgZI/wCEY1Lj/wAl6Pr+J/m/IPqtD+U+H/8Ah2X8bP8AoY/B
             X/f67/8AjVH/AA7L+Nn/AEMfgr/v9d//ABqvuGP9sT4Wl4xPrGp2Eb9Li+0DUIIR9ZHgCge5Nere
             G/E2k+L9HtdX0PU7TWNKuk8yC9sZlmhlX1VlJBo+v4n+b8g+qUP5T4G/ZF/Z68W/s9/tWTaZ4u1D
             Sb+7v/Di3MLaQ0rIqedKuG8xVOcqelFfRut/8nuaN/2Jw/8ASqeiuKc5VJOUnqzqjFQSjHY6nwR/
             ycX8Uf8AsFaH/wC3lc54j0+2+LH7Qt5perRrf6B4Hs7SeDSrmPdbz6pdeY/nOpG12hgRNgOQrTM3
             XBHR+CP+Ti/ij/2CtD/9vKxvCDhPjp8YGcZiW60cll+8h+xDDUR3CWxw3h/49eOP7B0fxhrWi6DB
             4DvNabSBNp97cHULBWvGs4pZEdfLZPMCblVsgPxnFdj4d+Pvh7Ujplpd6oZ729kRbhtItLqa1s2l
             uJIYGeUp+6EjxMo34yynHGCeL8P/AAK8appGm+D9e1zw9L4HsNZOsT2+m2c/2/UkW9a7ihdnby0X
             zCm4qCSEwMZzWZZfsx+IdPvPCD2fiDSLa40kxka9axXFvqKIt5JcSQIyMEnjkWTYUuAVUlmAOcVs
             rmWh6j8HvjJb/Ffw/p04ZI/EEtgl7qGmWxeSKFHkdIwZMbQ7BCwQndg5xgg1l+Gf2hbLxH8QdM8N
             paXFrDq/28aDqkt2jG/Fm5WfdADvjjJV9jnhth6HGc34A/Amf4EA29hqkD6PfQCbU7VEcFdWEh/0
             qMsTtWSIhHU8ZiQjAJrO+Gv7N8vw88e/2l9p01tDsL/UNRt47eCQ6hcPdBlRZ5XYr5UCySqiR4B3
             AkAg7jUND3U3D7P9ZJHEG/vcwP8A4f56UpuJcvuLFsfvYgx+cf31pnzbxgh5Cvyt2mT0PvSDG1Nr
             FUz+6kPWNv7je3+fSrESC4n3LtmZ5Mfu3LcTL/dPv/n1pBcPtXbNIkecRuWOYm/un2/z6VGcbX3K
             VTOZEHWNv76+3+fWlO7ewIDybfnX+GZPUe/+fSgB7TyYk3M4XrLGGPyn++v86X7RPv8A9YZJdvTd
             8s6f4/56VGvWPY+T/wAsZW7/AOw3+f1pPk2d44t3I/igf1+n+elAEq3EmI9k74/5Yysx4P8Acb/P
             60huH2Nl5EjB+dQxzC394e3+fWmNnMm9AzY/fRDo4/vr7/59KUbt67WDybf3bnpKv90+/wDn1oAe
             Z5tzhmZnx+8jDHEq/wB4e/8An0oFxNlNs7M2P3UhY4kH9xvf/PrUQ27FwxSPd8jnrC390+3+fSlb
             GJN6YGf30S/wns6/5/WgB4uH2DEskcQbg7uYH9Pp/npStcS/vN5f/ptEGP8A32v+f1pnzb+zy7f+
             Azp/j/npSLj93sfA6QyHqp/uN/n9aAJRcT7xiUvJt+UluJ09D700XD7U2zyKmcRSFjmNv7je3+fS
             ozt2NuBSMN86jrC394e3+fWlO7c4ZQ74/eRjpKv94e/+fSgB5uJNr7mdUz+9QMcxN/fX2/z607z5
             97ZcySbfmQNxMnqPf/PpUSk7o9r7mx+6lPRx/cb3/wA+tJ8nljBMcW7g/wAUD+n0/wA9KAJVuJcx
             7Lhyf+WMpY8/7Df5/WkNw+z/AFkkcYbkbuYH/wAP8fSmN/y03Jz/AMtol/8AQ1/z+tKN28YIeTb8
             rHpMnoff/PrQA8zzZcMWZsfvYgxw4/vr70C4n3JtmZ5CP3bluJV/un3/AM+tRDG2PaxVM4ikPWNv
             7je3b/IoONr7lKpnMqA8xt/fX2/z60ASC4cKu2aRIw2EYscwt/dPt/n0oNxJiTczhf8AltGGPyn+
             +v8AOmkNvbIDy7fmX+GZPUe9IvWPY+T/AMsZT3/2G/z+tAEvnz7/APWGSXb/AHvlnT/H/PSkFxLi
             PZO4GcQyljwf7jf5/Wovk2d44g3I7wP6j2/z0pWzmQOgZsfvYh0cf319/wDPpQA83D7Wy8iR5+dQ
             xzC394e3+fWlM8+59zM74/eRhjiVf7w9/wDPpTBu3JtYPIV/dyHpKv8Adb3/AM+tNG3auGKRhvkY
             9YW/un2/z6UASi4mym24Zmx+6lLHDj+43v8A59aT7Q+wYlkSMNwd3MD+n0/z0pjYxJuTAz++iH8J
             /vr/AJ/Wj5t/aSQr/wABnT/H/PQ0ASNPL+8Dl/8AptErH/vtf8/rQLifcMSl5dvysW+WZPQ+9RjG
             I9jYGf3Mp/hP9xv8/rSHbsbcCke751HWFv7w9v8APrQBILh9qbZ5FTOIpCTmNv7je3+fSg3Em19z
             OqZ/eoGOY2/vr7d/8mmHdvfcoeQr+8jHSVf7w9/8+lAJ3RlX3Nj91Kejj+43+f60ASmefc2XLybf
             mUNxMnqPekW4l/d7bhyf+WMrMef9hv8AP61F8uwYzHEG4P8AFA/+H+PpSt/y03x8/wDLaId/9tf8
             /rRYB/2hwh/eSRxZ5G7mBv8AA/19DXkdvcWvwe/aK8O2elQx6fo/j+C7XUtLtk2QJqFuI2jvkUcI
             ZEcxyYxuKxk8gk+sgtvXBDyFflY9Jk9D7/59a8X+LGD8ffgkBzD5mqbQfvL8ttlTUTWhUdzb1r/k
             9zRv+xNH/pVPRRrf/J7mjf8AYnD/ANKp6K5jY6nwR/ycX8Uf+wVof/t5WJ4RBPx3+MATiY3GkBQe
             j/6CMrW34I/5OL+KP/YK0P8A9vK5jTrmSz+K3x1uUPMC6bKMfeRl04srj6EVcPiJlsQaz4317xNP
             PF4UvLTRdHtpWhTVrm1+1TzSKSr+ShYIsasCoZ924g4XGCaDR+NGDj/hYV7tc5I/saw4PqP3XWq/
             gCBbbwF4ZjU5H9l2rEnuTErE/iSaxPGa65b+I4b7T5biKzt7Ys7OcWy4DlmbDcn7uQVOeMEYNfLT
             x1edR2lYwudJt8bFyx+IV6Sw2t/xJrD5h7/uuaQJ42Xy8fEO9yn3T/Y9hnHp/qulcVcap441S0il
             gtpIIrmCG5TyYkDRZkVjGSTydhIP0NTJqHxAnSPdbRW7EHf+4RsE5yOW6A4x6is/rWJ/5+CuzsY7
             jx3ZfNB40i1DncLfVNHgEWfZoPLZfrk9ehrvvBPi8eL7C6aa0Fnq1lJ9m1LTt+8BtoIdGwNyspDK
             2BkHBAI45CzaV7O3a4UJO0amRR0VsDcPzzUnw8wPiV4qBJjVtM0x/MH8MnmXign6gAfQAV6OXYut
             Uq+zqO6GiTx58QdTg1l9B8MzW0N7aoj3mrXUXnLbq4ykKx5AeQj5iWOFBUkEtiuQGp+OgqgeP7ob
             W3LjRrH5fp+66VHblpPFXjiWQASt4hukbHoiRov/AI6BV6vmcxzbFxxU4U58qTtY/SMvyrCvDQnU
             hdtXKx1Px0wkB8f3O1+WH9jWOM+v+q60v9reO9+7/hYF0W27STo1h8w9/wB1zViivN/tbHf8/X+B
             6P8AZWC/59IrDU/HahAPiBdDYcqf7Hscj2/1XSg6n46Ksv8Awn90Ax3YGjWPB9R+64qzRR/a2O/5
             +v8AAP7KwX/PpFc6r46LMx8f3J3DDD+xrDDfX91SLqvjtShHxBu8oMA/2PY5x6H91Vmil/a2O/5+
             v8A/srBf8+kVf7S8dbNo8f3QAbcuNGsflPt+64pW1Tx03mZ8f3JEn3h/Y1jg+/8AqutWaKf9rY7/
             AJ+v8A/srBf8+kVxqnjzcrf8LAuiwG3P9jWPI9/3XNINT8dKqAfEC6Gw5X/iTWPHsP3XSvPdbsPF
             b+JbxbRrv+zftSQxsshAMU+DJIP+uWzA9Nxp9rqXjS1s/ltJGCoUEUlvvdf3YbfknLHdkBT16Vv/
             AGjjrX9sc/1DBXt7E79tT8dMrqfH90A5yR/Y1h19R+64NKdV8dlyx8f3JJXa2dGsPmHv+65rgLHU
             vGUYWFIJ33tK8b3NrjepeU7nOf3ZAEYVO4b8hNf8ctaJPNpfkv8AaEX7PHBudo2BfOegwGVDnurc
             ij+0cf8A8/iv7PwP/Pk74ap47Xy8fEC6zH90/wBj2Ocen+q6Un9p+OthX/hP7oDduGNGsflPqP3X
             FWj146UVh/a2O/5+s2/srBf8+kVjqnjpi5Pj+5O8YYf2NYYP/kKgar47DI3/AAsC6LKNu46PY5I9
             D+65qzRR/a2O/wCfrD+ysF/z6RVGp+OgqqPH90Arblxo1j8p9v3XFKdT8dN5gPj+52vyw/saxxn1
             /wBV1qzRR/a2O/5+v8A/srBf8+kV/wC1vHe/efiBdFtu0k6NY/MPf91zSLqfjpQgHxAuhsOVP9j2
             OR7f6rpVmil/a2O/5+sP7KwX/PpFU6l45Ksv/Cf3QDHdgaNY8H1H7ritDS/iR4k8I3S3PiTUoPEW
             hORHd3Bsktrm2UnAkIjwkiDPzDarAZOTjFQ1j+MgG8G+IARkf2bc8H/rk1b0M4xsKkW6ja7GFfKM
             HKnJRgk7bnvep3/9nW8boDPM7iK0wcGRz0jY9hwTnsAT2qp/YurzqWl11rTLbjDZ2kRSFvYuGYj3
             4+grO0x2lg8D+Zku9sskyZzuP2MkOPel+JOn6zqmnaXb6JlrprwFz50kMckQik4keMhgN23kdyK+
             yzHFVYVVThKysfmsIpq7NFtA1UmQN4juSWH7xBZ2+G9x8nWgaDq25SPE1yXxhWNnb/OPQ/JXB6Zr
             Xjuys47f7LdPBb2MCia6sy9wH/diVyejuCZRsz8wUeuTdPiDxwbi5EenyvHFbGYRS2IiEgVEYENu
             OJJG3oY/4eD9fL+tYn/n4acsex1w0DUwqgeJbpVB+U/Y7fMZ9PudKU+H9UPmBvEd1gnLoLO34P8A
             eHyVxja78QzczIbGNWe3hZAtoXB3tGWOfulkDOpUn+DP1uQax4h1bRvF8KuLubTGaxsbi1Xa11KD
             uLAqePlZFIHRlaj61if+fgcsex1H9g6rvz/wklyzlcf8edtiRf8AvjrSLoGqAR48TXQ2/wCrc2dv
             kf7J+SuKGv8Aj6CaWWWxeW0Vn/0eKxAdOJ9uG3c48uE+/mVlR/ELxtDqFtYXFrGdUkDCOxa1C/a1
             /f7ZGyQUJ8uPAxggnpTWKxX/AD8Hyx7HpLaVrFmjSRar/aAB3Na3NvHHz/sPGBtPuQR7V5L8S72L
             Ufjx8DrqMMDK2qE5GM4W3HI9QQQfQj6V634IvdWv/D8E2sDbqBdwpMJiLoD8oZSBg/h714v42yPj
             z8JFBzEura8FU9U+a34+lepl+Kq1ZSp1He2pnKKTTR1+t/8AJ7mjf9icP/SqeijW/wDk9zRv+xOH
             /pVPRXsAdT4I/wCTi/ij/wBgrQ//AG8rnvDtouofGr40WrMYzcPpcPmdiG0/aQfwOa6HwR/ycX8U
             f+wVof8A7eVz88qeDP2k/EVlfsyWfjfTLS9053OFlurMPFcQof8AnoImgkC9Socj7pq4b6ky2OZ8
             BNNF4S0+wukMWoaVEumXkLfeimhAjIP1Chge4YEcGt+uh8VfDLSvFmoLfyS3+mayIwn9o6PdG2lu
             Yh91X4KvjPG5Tjtwaxf+FJ2zcr408ZBH4RzqMPyt/dI8ivAqZVUc24NWOexDSVN/wpS2GWbxj4zV
             V+WRf7RhzGfX/Ucil/4UjCPl/wCEx8ZNIvJUajD+8X1H7jr7Vn/ZNbuv6+QWIQMnA5NO+GMEl74x
             8W6tCPMsvJtNLTP3bh4TM82099pnVc+oYfSVPgjp8jKtx4o8WahbvysVxqgSOX1RzFGjjuOGFd1p
             umWej6Zb2NhapYadbgRwwQqFFqR0AHp/ifWvQwWXzw9T2k2NHid5ZNovjzxbYOWxd3p1e1Z+skMy
             IGI9dsiOh9OM9RVivUfFvgfSfG1vHFq1pI09sxkjntZWhuICRgyQyKQwyOo6HGCDiuP/AOFBaeSF
             Txb4wJPzRn+04sSD0z5PBrw8dkFavXlVpSVpO+p9rgs9pUKEaVWLvHTQ56iuh/4UJpp5Hi/xiI34
             DHUYvkb0I8ij/hQmnrkt4r8YjZxKg1KIlf8AaH7jkV5/+reK/mj+P+R3/wCseF/ll+H+Zz1FdD/w
             oKwB2jxb4wZx8wA1KLEi+o/cdaT/AIUHpzY2+MPGO2T/AFbnUYsZ/un9xxT/ANW8V/NH8f8AIP8A
             WPC/yy/D/M5+iuh/4ULp2Nx8WeMlQfLIP7SizGfX/Ucij/hQVgvB8WeMS6csg1KL5l/vD9x+lL/V
             vFfzR/H/ACD/AFjwv8svw/zOeorof+FBaecBfF/jBi3zRN/aUWH/ANn/AFHBo/4UJppG7/hLvGSo
             3yljqMWY29D+4o/1bxX80fx/yD/WPC/yy/D/ADOeoroP+FCaeuS3ivxjuT/WINSiyB/eH7jkUv8A
             woKw+6PF3jBn+8n/ABM4sSr/AN+ODR/q3iv5o/j/AJB/rHhf5Zfh/mc9RXQf8KE01hx4v8YhH4Rz
             qMXyt/dYeRS/8KF04ZZvFnjJQvyyL/aUWYz6/wCo5FH+reK/mj+P+Qf6x4X+WX4f5nPUV0P/AAoK
             xHy/8JZ4xaRfm2jUov3i+o/cdfaj/hQennAXxf4wIfmJzqUWD/sn9xwaf+reK/mj+P8AkH+seF/l
             l+H+Zz1FdB/woXTfvHxb4yVPutnUosxN7/uOlL/woOwXOfFfjEun30GpRcr/AHh+4/Sl/q3iv5o/
             j/kH+seF/ll+H+Zz1FdD/wAKCsDhV8XeMGY/NG39pxYkHp/qODSf8KE00jP/AAl/jFUfgMdRi+Rv
             QjyKf+reK/mj+P8AkH+seF/ll+H+Zz9FdD/woTTxkt4s8YjZxKg1KIlf9ofuORR/woKwHyjxb4wa
             QfMANSixIvqP3HWj/VvFfzR/H/IP9Y8L/LL8P8znqxfGZdvC2pW0MbT3d9C9hawJ96aaVTGiKO5J
             b8ACegru/wDhQenN93xf4x2v/q3OoxYz/dP7jitvwr8KNC8J6iNTDajqmooDGt9q90bia0J6mMYC
             ID3KqCR3xxW1HhyuqidSat5b/kY1uIqMqbVODv52t+ZpS2v9hWnhZpJN1vphS1a4/wCeeYfJO723
             Y/P2rqG4Dbl2jPzKOqH1FVpYvMWVJYll3LtmhK5WZCMbgP6fh6Vjr4YEOxLPVdUs48fuUhusxlf7
             vzqxFfTY7ASxM1OD8tT4iE+XRnQ85OQGbHI7OPUe9Az8uG5/gc9/9k1z48Py7c/2/riR5wCbiPMT
             eh/d9KD4enG7drmt/L/rYxcR/wDfa/u68z+ya/df18jT2sToOAvdVz+MZ/wpFjWMMFjVR1eNBgH/
             AGhWB/wjtzkAa/rTyYyp+0R4mX0/1fWgeHpiF2+IdbVWOI5DPHlG/ut+7o/smv3X9fIXtonQc5GD
             ubHyt2ceh96Z5UZdZNqhl4SQqNyeq59Kwj4flwxbXdcVAcSJ9ojzGf7w/d9P8+tH/CO3IYg67rTy
             AZZRcR4lX1H7vrR/ZNfuvx/yH7WJvu6IkjyEJGoLS5OAgHO/Pp3r578bKx+OfwYuHjMbXl5rV2uR
             jdG5gKH64wfxr2ZfDUcjxG51DUNTTO6Fb2fdESOdrqqqD+Of0ryH4g6rb+JP2nvhvo2mMZ7vw1Hc
             3mqohyLU3XlJDA3o7CN5MdQqA9GFelg8DLC805vVkOfM9Dp9b/5Pc0b/ALE4f+lU9FGtf8nuaN/2
             Jw/9Kp6K9AZvW+pweCf2mdVh1Mi3t/GmjWa6VdSHakt1ZtOJrYH/AJ6GOeORR1YLJj7hrufiL8Nt
             A+K3hibQvEdj9ssXdZonVmjmtplOUmikUho5FPIZSD17E0/4hfDvw98UPC9x4f8AEunR6lps7LIF
             YlXikU5SWNxhkdTyGUgivE5v2StehkMen/GHx9aWS8RQ/wDCQXB2L6ZYsT+JoArzfsl+LIZDHYfG
             jxxBZI2YYn1YsUH1ZGYn3JNMP7J/jc78/G3xqd/3v+JmOf8AyFVj/hk/xV/0Wnx9/wCD6b/Cj/hk
             /wAVf9Fp8ff+D6b/AAp3YrIg/wCGUvHO4N/wu7xtuxtz/ag6f9+qQfsn+OAEA+NvjYBDlf8AiaDj
             /wAhVY/4ZP8AFX/RafH3/g+m/wAKP+GT/FX/AEWnx9/4Ppv8KLsLFc/sn+NyGH/C7fGuGOSP7THJ
             9f8AVUf8Mo+ONxb/AIXd42ywwT/aY5H/AH6qx/wyf4q/6LT4+/8AB9N/hR/wyf4q/wCi0+Pv/B9N
             /hRdhYrj9lDxwuzHxu8bDYML/wATQcf+QqP+GT/G+3b/AMLt8a7d27H9pjr6/wCqqx/wyf4q/wCi
             0+Pv/B9N/hR/wyf4q/6LT4+/8H03+FF2Fiuf2UPHDb8/G3xqd4w3/EzHP/kKlH7KPjkMrf8AC7vG
             25RgH+1B0/79VP8A8Mn+Kv8AotPj7/wfTf4Uf8Mn+Kv+i0+Pv/B9N/hRdhYrD9k/xuAoHxt8agKc
             r/xNBwfb91Sn9k/xuQ4Pxt8a4flh/aY5P/fqrH/DJ/ir/otPj7/wfTf4Uf8ADJ/ir/otPj7/AMH0
             3+FF2FiD/hlHxzuLf8Lu8bbiNpP9qDkf9+qQfsoeOFCY+NvjYbPu/wDE0HH/AJCqx/wyf4q/6LT4
             +/8AB9N/hR/wyf4q/wCi0+Pv/B9N/hRdhYrn9k/xuVK/8Lt8bbSd2P7THX1/1VB/ZR8cEsT8bvGx
             LDDf8TMcj/v1Vj/hk/xV/wBFp8ff+D6b/Cj/AIZP8Vf9Fp8ff+D6b/Ci7CxXH7KPjgFSPjd42yow
             D/ag4H/fqk/4ZP8AG4UL/wALt8a4B3Af2mOD/wB+qs/8Mn+Kv+i0+Pv/AAfTf4Uf8Mn+Kv8AotPj
             7/wfTf4UXYWK5/ZQ8cHfn42+NTv+9/xMxz/5Cpf+GUvHO4N/wu7xtuxtz/ag6en+qqf/AIZP8Vf9
             Fp8ff+D6b/Cj/hk/xV/0Wnx9/wCD6b/Ci7CxXH7J/jcBAPjb42AQ5X/iaDj/AMhUH9k/xuQw/wCF
             2+NcMckf2mOT6/6qrH/DJ/ir/otPj7/wfTf4Uf8ADJ/ir/otPj7/AMH03+FF2FiD/hlHxwWLH43e
             NssME/2oOR/36pB+yh44XZj43eNgU4X/AImg4/8AIVWP+GT/ABV/0Wnx9/4Ppv8ACj/hk/xV/wBF
             p8ff+D6b/Ci7CxX/AOGT/G+3b/wu3xrtzux/aY6+v+qoP7KHjg78/G3xqd4w3/EzHP8A5Cqx/wAM
             n+Kv+i0+Pv8AwfTf4Uf8Mn+Kv+i0+Pv/AAfTf4UXY7EA/ZR8chlb/hd3jbcowD/ag6f9+qQfsn+N
             wFA+NvjYBTlf+JmOD7fuqsf8Mn+Kv+i0+Pv/AAfTf4Uf8Mn+Kv8AotPj7/wfTf4UXYrFc/sn+N2D
             g/G3xqQ/LD+0xyf+/VL/AMMo+OC27/hd3jbdjaT/AGoOn/fqp/8Ahk/xV/0Wnx9/4Ppv8KP+GT/F
             X/RafH3/AIPpv8KLsLFcfsoeOFCY+NvjYbPu/wDE0HH/AJCpP+GT/G5Ur/wu3xtgncR/aY6+v+qq
             z/wyf4q/6LT4+/8AB9N/hR/wyf4q/wCi0+Pv/B9N/hRdhYrn9lHxwzMT8bvGxLDDf8TMcj/v1QP2
             UfHAKkfG7xtlRhT/AGoOB/36qx/wyf4q/wCi0+Pv/B9N/hR/wyf4q/6LT4+/8H03+FF2OxX/AOGT
             /G4UL/wu3xrgHcB/aY4P/fqg/soeOGD5+NvjU7/vf8TMc/8AkKrH/DJ/ir/otPj7/wAH03+FH/DJ
             /ir/AKLT4+/8H03+FF2KxB/wyj453Bv+F3eNtwG3P9qDp/36po/ZP8bqEA+NvjYBDlf+JmOP/IVW
             f+GT/FX/AEWnx9/4Ppv8KP8Ahk/xV/0Wnx9/4Ppv8KLsLFcfsm+MnDJcfGfxrcQPzJEdXaPf/wAC
             SMMPqCDXonwc/Z80T4RRPJbKJ7tpHlMmWdmlf78sjuS8kjd3Yk1wf/DJ/ir/AKLT4+/8H03+FMm/
             ZE1y/he31L4seNtVs5BtktLrxBdCNx6HYynHtmluFiTStftfHf7ZtzqOiyfa9O8P6KNBuruNt0Ul
             55kk0qKRwfKVkViOjSFeqmivVfhP8HdD+EekRWOlQRR+XGIkEMYjjiTOdqKOmTyScknk0UDP/9k=")
             
             do_InputPicture -File $partitionPic
        }

        "Default UEFI/GPT"
        {
             $gptSystemLabel.Visible = $True
             $systemGPTTextbox.Visible = $True
             $gptMSRLabel.Visible = $True
             $gptMSRTextbox.Visible = $True
             $gptWindowsLabel.Visible = $True
             $gptWindowsTextbox.Visible = $True
             #---------------------------------
             $MbrSystemLabel.Visible = $False
             $systemTextbox.Visible = $False
             $MbrWindowsLabel.Visible = $False
             $windowsTextbox.Visible = $False
             $MbrRecoveryLabel.Visible = $False
             $recoveryTextbox.Visible = $False
             $gptWinRELabel.Visible = $False
             $gptWinRETextbox.Visible = $False
             $gptRecoveryLabel.Visible = $False
             $gptRecoveryTextbox.Visible = $False
             
             # DefaultUEFI_GPT
             $partitionPic = [System.Convert]::FromBase64String(
             "/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsK
             CwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQU
             FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCABcAVsDASIA
             AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
             AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
             ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
             p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
             AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
             BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
             U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
             uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9Cvjt
             8c9F+A/hWDVtUguNTvr64FlpukWRXz72cqW2ruICqqqzM7cKBnrgH5muv29viCZmNt8M9AWH+ETe
             JnZh9SLbFZv7cepb/wBqf4S6beYmsDpzbIH+7ulvoI5Tj3RVX6Z9arax4Hs/G2pXVlqWjW/ge6t/
             FF1punmzszaNqNjFbyysFRuHYeWgDgfx9+lexhsPRlTU6t9e3kebXrVVNxp9DW/4b2+JH/RNPDf/
             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")
             
             do_InputPicture -file $partitionPic
        }

        "Recommended UEFI/GPT"
        {
             $gptWinRELabel.Visible = $True
             $gptWinRETextbox.Visible = $True
             $gptSystemLabel.Visible = $True
             $systemGPTTextbox.Visible = $True
             $gptMSRLabel.Visible = $True
             $gptMSRTextbox.Visible = $True
             $gptWindowsLabel.Visible = $True
             $gptWindowsTextbox.Visible = $True
             $gptRecoveryLabel.Visible = $True
             $gptRecoveryTextbox.Visible = $True
             #----------------------------------
             $MbrSystemLabel.Visible = $False
             $systemTextbox.Visible = $False
             $MbrWindowsLabel.Visible = $False
             $windowsTextbox.Visible = $False
             $MbrRecoveryLabel.Visible = $False
             $recoveryTextbox.Visible = $False

             # RecomendedUEFI_GPT
             $partitionPic = [System.Convert]::FromBase64String(
             "/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsK
             CwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQU
             FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCABdAVoDASIA
             AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
             AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
             ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
             p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
             AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
             BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
             U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
             uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD66/aq
             /aZ1f4aeINM8DeCUtH8W39q1/d313C1wmm2u4ohEKkeZLIwYKpIAEbk54B+brr9oj44wTss3xQNq
             5+byn8MWiED6MM4rc+LHiq28Nf8ABRySbUL2Ozs47TTmaeeURrGotrj+I8LyePdqYPHXhD4kp4Uu
             LrU4dSgXSb42dv4l1FJrwamJU3W907PEDEEy8WWVW5GcjFe9hqNFU4ucOa+t9fPT8DyK9WpztRla
             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
             s9jYW9o7cF4ogpP41obaAP/Z")

             do_InputPicture -file $partitionPic
        }

        "Boot USB Flash Drive"
        {
                
            $gptWinRELabel.     Visible = $False
            $gptWinRETextbox.   Visible = $False
            $gptSystemLabel.    Visible = $False
            $systemGPTTextbox.  Visible = $False
            $gptMSRLabel.       Visible = $False
            $gptMSRTextbox.     Visible = $False
            $gptWindowsLabel.   Visible = $False
            $gptWindowsTextbox. Visible = $False
            $gptRecoveryLabel.  Visible = $False
            $gptRecoveryTextbox.Visible = $False

            $MbrSystemLabel.    Visible = $False
            $systemTextbox.     Visible = $False
            $MbrWindowsLabel.   Visible = $False
            $windowsTextbox.    Visible = $False
            $MbrRecoveryLabel.  Visible = $False
            $recoveryTextbox.   Visible = $False

            # UsbTool
            $partitionPic = [System.Convert]::FromBase64String(
            "/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAMCAgMCAgMDAwMEAwMEBQgFBQQEBQoHBwYIDAoMDAsK
            CwsNDhIQDQ4RDgsLEBYQERMUFRUVDA8XGBYUGBIUFRT/2wBDAQMEBAUEBQkFBQkUDQsNFBQUFBQU
            FBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBT/wAARCAB2ATsDASIA
            AhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQA
            AAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3
            ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWm
            p6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEA
            AwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSEx
            BhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElK
            U1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3
            uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9UXbA
            zTN+7+E0rnaBTd4oAfvPpSGQ/wB2m7hQWHpQAplA/hpfM9qjL8dfzpck45HSgBxlx/DSiXPam546
            ijdnPI/CgB+8+lG8+lRlxn8KXcKAH7z6Ubz6UzcKNwoAfvPpRvPpTNwo3CgB+8+lG8+lM3CjcKAH
            7z6Ubz6UzcKNwoAfvPpRvPpTNwo3CgB+8+lG8+lM3CjcKAH7z6Ubz6UzcKNwoAfvPpRvPpTNwo3C
            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")
            do_InputPicture -file $partitionPic
        }
    } 
}
#..............................................................................

#..............................................................................
Function do_InputPicture ($file)
{
    $inputPicture.Image = $file

    $objFormatHardDrive.refresh()
}
#..............................................................................

#..............................................................................
Function do_Exit
{
   $objFormatHardDrive.Close()
}
#..............................................................................
# Form and form controls
#..............................................................................

$objFormatHardDrive = New-Object System.Windows.Forms.Form

$objFormatHardDrive.Text            = "Format Disk Utility"  
$objFormatHardDrive.Size            = New-Object System.Drawing.Size(880,500)
$objFormatHardDrive.StartPosition   = "CenterScreen"  
$objFormatHardDrive.BackColor       = "White"
$objFormatHardDrive.FormBorderStyle = "Fixed3D"
$objFormatHardDrive.Topmost         = $True  

# Create a ToolTip
$objToolTipInfo = New-Object 'System.Windows.Forms.ToolTip'
        
$DiskDrives = Get-CimInstance Win32_DiskDrive | Select @{Label="Drive";Expression={$_.index}},InterfaceType,@{Label="Size(GB)";Expression={$_.size/1GB}},Caption, Partitions, Status| Sort-Object Drive

$DiskDrives | Out-File diskPartFile.txt

$DrivesCollection = ($DiskDrives | Select drive).drive

$ArrayDisk = 2..((Get-Content diskPartFile.txt).length-4)

$DiskInfo = Get-Content diskPartFile.txt | Select-Object -index $ArrayDisk

remove-item diskPartFile.txt
    
$DiskBox          = New-Object System.Windows.Forms.RichTextBox
$DiskBox.location = New-Object System.Drawing.Size(20,20) 
$DiskBox.Size     = New-Object System.Drawing.Size(400,160) 
$DiskBox.font     = "lucida console"

foreach ($Line in $DiskInfo)
{
    if ($Line[0] -ne "")
    {
        $DiskBox.appendtext($Line  + [char]13 + [char]10)
    }
}

$DiskBox.Visible    = $True
$DiskBox.wordwrap   = $false
$DiskBox.multiline  = $true
$DiskBox.readonly   = $true
$DiskBox.scrollbars = "Vertical"

$objFormatHardDrive.controls.add($DiskBox)

$DropDownLabel          = New-Object System.Windows.Forms.Label
$DropDownLabel.Location = New-Object System.Drawing.Size(20,193) 
$DropDownLabel.size     = New-Object System.Drawing.Size(100,20) 
$DropDownLabel.Text     = "Select a drive:"

$objFormatHardDrive.Controls.Add($DropDownLabel)

$DropDown               = New-Object System.Windows.Forms.ComboBox
$DropDown.Location      = New-Object System.Drawing.Size(120,190)
$DropDown.Size          = New-Object System.Drawing.Size(130,30)
$DropDown.DropDownStyle = 2

$objToolTipInfo.SetToolTip($DropDown, "Select disk to be formated/partitioned")

ForEach ($Drive in $DrivesCollection)
{
	[void]$DropDown.Items.Add($Drive)
}

$objFormatHardDrive.Controls.Add($DropDown)

$formatDiskButton = New-Object System.Windows.Forms.Button  

$formatDiskButton.Location  = New-Object System.Drawing.Size(50,410)  
$formatDiskButton.Size      = New-Object System.Drawing.Size(120,25)
$formatDiskButton.BackColor = "ButtonFace"
$formatDiskButton.TabIndex  = 2
$formatDiskButton.Text      = "Format Disk" 

$objToolTipInfo.SetToolTip($formatDiskButton, "Click this button to format/partition Selected disk")

$formatDiskButton.Add_Click(
{
    If($Script:dpoutput)
    {
        $Script:dpoutput.Clear()
        $Script:dpoutput.Visible=$False
    }

    $diskNumber = $DropDown.SelectedItem.ToString()
    
    if ($diskNumber -ne $null)
    {
        $confirm = [System.Windows.Forms.MessageBox]::Show("Are you sure you want to format Disk " + $diskNumber + "?" , "Confirm FORMAT!" , 4)
        if ($confirm -eq "YES")  
        {
            #..............................................................................
            # -------------| Get DiskPartFile command |--------------------
            #..............................................................................
            If ($radioButtonOne.Checked)
            {
                $Script:command =
                @"
                Select disk $diskNumber
                clean
                create partition primary size="$($systemTextbox.Text)"
                format quick fs=ntfs label="System"
                assign letter="S"
                active
                create partition primary
                format quick fs=ntfs label="Windows"
                assign letter="W"
                exit
                "@
                }
                ElseIf ($radioButtonTwo.Checked)
                {
                $Script:command = @"
                Select disk $diskNumber
                clean
                create partition primary size="$($recoveryTextbox.Text)"
                format quick fs=ntfs label="Recovery"
                assign letter="R"
                set id=27
                create partition primary size="$($systemTextbox.Text)"
                format quick fs=ntfs label="System"
                assign letter="S"
                active
                create partition primary
                format quick fs=ntfs label="Windows"
                assign letter="W"
                exit
                "@
                }
                ElseIf($radioButtonThree.Checked){
                # Note for EFI partiton: for Advanced Format Generation 4Kn drives, change to size=260.
                $Script:command = @"
                Select disk $diskNumber
                clean
                convert gpt
                create partition primary size="$($gptWinRETextbox.Text)"
                format quick fs=ntfs label="Windows RE tools"
                assign letter="T"
                set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
                create partition efi size="$($systemGPTTextbox.Text)"
                rem == Note: for Advanced Format Generation One drives, change to size=260.
                format quick fs=fat32 label="System"
                assign letter="S"
                create partition msr size="$($gptMSRTextbox.Text)"
                create partition primary
                format quick fs=ntfs label="Windows"
                assign letter="W"
                "@
                }
                ElseIf($radioButtonFour.Checked){
                $Script:command = @"
                Select disk $diskNumber
                clean
                convert gpt
                create partition primary size=300
                format quick fs=ntfs label="Windows RE tools"
                assign letter="T"
                set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
                gpt attributes=0x8000000000000001
                create partition efi size="$($systemGPTTextbox.Text)"
                format quick fs=fat32 label="System"
                assign letter="S"
                create partition msr size="$($gptMSRTextbox.Text)"
                create partition primary
                shrink minimum="$($gptRecoveryTextbox.Text)"
                format quick fs=ntfs label="Windows"
                assign letter="W"
                create partition primary
                format quick fs=ntfs label="Recovery image"
                assign letter="R"
                set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
                gpt attributes=0x8000000000000001
                "@
                }
                ElseIf($radioButtonFive.Checked){
                $Script:command = @"
                Select disk $diskNumber
                clean
                create partition primary
                Select partition 1
                format quick fs=ntfs
                active
                assign
"@
            }
            Else
            {
                [System.Windows.Forms.MessageBox]::Show("Please Select Select BIOS/UEFI Partitions option!")

                return
            }
            #..............................................................................
            # -------------| End DiskPartFile command |--------------------
            #..............................................................................

            $Script:dpoutput = New-Object System.Windows.Forms.RichTextBox
            $Script:dpoutput.location = New-Object System.Drawing.Size(20,225) 
            $Script:dpoutput.Size = New-Object System.Drawing.Size(400,150) 
            $Script:dpoutput.font = "lucida console, 7pt"
            $Script:dpoutput.Visible= $true
            $Script:dpoutput.wordwrap = $true
            $Script:dpoutput.multiline = $true
            $Script:dpoutput.readonly = $true
            $Script:dpoutput.scrollbars = "Both"
            $Script:dpoutput.appendtext("Loading DISKPART..." + [char]13 + [char]10)
            $objFormatHardDrive.controls.add($Script:dpoutput)
            #..............................................................................
            # $Script:dpoutput.appendtext($command ) #/-> For testing
            #..............................................................................

            $Script:dpoutput.appendtext(($command | diskpart))

            $objFormatHardDrive.controls.add($Script:dpoutput)
        }
    }
    else
    {
        [System.Windows.Forms.MessageBox]::Show("Please Select a disk to format!")
    }
})
#..............................................................................

#..............................................................................

$objFormatHardDrive.Controls.Add($formatDiskButton)

# Create first radiobutton
$radioButtonOne = New-Object System.Windows.Forms.Radiobutton
$radioButtonOne.text = "Default BIOS/MBR"
$radioButtonOne.height = 20
$radioButtonOne.width = 210
$radioButtonOne.top = 30
$radioButtonOne.left = 15
$radioButtonOne.add_click({do_ViewPartition})

# Create second radiobutton
$radioButtonTwo = New-Object System.Windows.Forms.Radiobutton
$radioButtonTwo.text = "Recommended BIOS/MBR"
$radioButtonTwo.height = 20
$radioButtonTwo.width = 210
$radioButtonTwo.top = 60
$radioButtonTwo.left = 15
$radioButtonTwo.add_click({do_ViewPartition})

# Create third radiobutton
$radioButtonThree = New-Object System.Windows.Forms.Radiobutton
$radioButtonThree.text = "Default UEFI/GPT"
$radioButtonThree.height = 20
$radioButtonThree.width = 210
$radioButtonThree.top = 30
$radioButtonThree.left = 230
$radioButtonThree.add_click({do_ViewPartition})

# Create fourth radiobutton
$radioButtonFour = New-Object System.Windows.Forms.Radiobutton
$radioButtonFour.text = "Recommended UEFI/GPT"
$radioButtonFour.height = 20
$radioButtonFour.width = 210
$radioButtonFour.top = 60
$radioButtonFour.left = 230
$radioButtonFour.add_click({do_ViewPartition})

# Create fifth radiobutton
$radioButtonFive = New-Object System.Windows.Forms.Radiobutton
$radioButtonFive.text = "Boot USB Flash Drive"
$radioButtonFive.height = 20
$radioButtonFive.width = 210
$radioButtonFive.top = 90
$radioButtonFive.left = 15
$radioButtonFive.add_click({do_ViewPartition})

#..............................................................................
# --- MBR ---
#..............................................................................

#  MBR System Label
$MbrSystemLabel = New-Object System.Windows.Forms.Label

$MbrSystemLabel.Location = New-Object System.Drawing.Size(15,140) 
$MbrSystemLabel.size     = New-Object System.Drawing.Size(80,20) 
$MbrSystemLabel.Text     = "System:"
$MbrSystemLabel.Visible  = $False

# MBR System Text Box
$systemTextbox = New-Object System.Windows.Forms.TextBox

$systemTextbox.Location = New-Object System.Drawing.Size(100,140)
$systemTextbox.Size     = New-Object System.Drawing.Size(70,20)
$systemTextbox.Text    = 350

$systemTextbox.Add_TextChanged(
{
    $this.Text = $this.Text -replace '\D'
})

$systemTextbox.Visible = $False

#  MBR Windows Label
$MbrWindowsLabel          = New-Object System.Windows.Forms.Label
$MbrWindowsLabel.Location = New-Object System.Drawing.Size(15,170) 
$MbrWindowsLabel.size     = New-Object System.Drawing.Size(80,20) 
$MbrWindowsLabel.Text     = "Windows:"
$MbrWindowsLabel.Visible  = $False

# MBR Windows Text Box
$windowsTextbox          = New-Object System.Windows.Forms.TextBox
$windowsTextbox.Location = New-Object System.Drawing.Size(100,170)
$windowsTextbox.Size     = New-Object System.Drawing.Size(70,20)
$windowsTextbox.Text     = "XXXXXX"
$windowsTextbox.ReadOnly = $True
$windowsTextbox.Visible  = $False

#  MBR Recovery Label
$MbrRecoveryLabel          = New-Object System.Windows.Forms.Label
$MbrRecoveryLabel.Location = New-Object System.Drawing.Size(15,200) 
$MbrRecoveryLabel.size     = New-Object System.Drawing.Size(80,20) 
$MbrRecoveryLabel.Text     = "Recovery:"
$MbrRecoveryLabel.Visible  = $False

# MBR Recovery Text Box
$recoveryTextbox          = New-Object System.Windows.Forms.TextBox
$recoveryTextbox.Location = New-Object System.Drawing.Size(100,200)
$recoveryTextbox.Size     = New-Object System.Drawing.Size(70,20)
$recoveryTextbox.Text     = 15000

$recoveryTextbox.Add_TextChanged(
{
    $this.Text = $this.Text -replace '\D'
})

$recoveryTextbox.Visible = $False

#..............................................................................
# --- GPT ---
#..............................................................................

#  GPT WinRE Label
$gptWinRELabel          = New-Object System.Windows.Forms.Label
$gptWinRELabel.Location = New-Object System.Drawing.Size(220,120) 
$gptWinRELabel.size     = New-Object System.Drawing.Size(80,20) 
$gptWinRELabel.Text     = "WinRE:"
$gptWinRELabel.Visible  = $False

# GPT WinRE Text Box
$gptWinRETextbox          = New-Object System.Windows.Forms.TextBox
$gptWinRETextbox.Location = New-Object System.Drawing.Size(315,120)
$gptWinRETextbox.Size     = New-Object System.Drawing.Size(70,20)
$gptWinRETextbox.Text     = 350

$gptWinRETextbox.Add_TextChanged(
{
    $this.Text = $this.Text -replace '\D'
})

$gptWinRETextbox.Visible = $False

#  GPT System Label
$gptSystemLabel          = New-Object System.Windows.Forms.Label
$gptSystemLabel.Location = New-Object System.Drawing.Size(220,150) 
$gptSystemLabel.size     = New-Object System.Drawing.Size(80,20) 
$gptSystemLabel.Text     = "System:"
$gptSystemLabel.Visible  = $False

# GPT System Text Box
$systemGPTTextbox          = New-Object System.Windows.Forms.TextBox
$systemGPTTextbox.Location = New-Object System.Drawing.Size(315,150)
$systemGPTTextbox.Size     = New-Object System.Drawing.Size(70,20)
$systemGPTTextbox.Text     = 350

$systemGPTTextbox.Add_TextChanged(
{
    $this.Text = $this.Text -replace '\D'
})

$systemGPTTextbox.Visible = $False

#  GPT MSR Label
$gptMSRLabel          = New-Object System.Windows.Forms.Label
$gptMSRLabel.Location = New-Object System.Drawing.Size(220,180) 
$gptMSRLabel.size     = New-Object System.Drawing.Size(80,20) 
$gptMSRLabel.Text     = "MSR:"
$gptMSRLabel.Visible  = $False

# GPT MSR Text Box
$gptMSRTextbox          = New-Object System.Windows.Forms.TextBox
$gptMSRTextbox.Location = New-Object System.Drawing.Size(315,180)
$gptMSRTextbox.Size     = New-Object System.Drawing.Size(70,20)
$gptMSRTextbox.Text     = 128

$gptMSRTextbox.Add_TextChanged(
{
    $this.Text = $this.Text -replace '\D'
})

$gptMSRTextbox.Visible = $False

#  GPT Windows Label
$gptWindowsLabel          = New-Object System.Windows.Forms.Label
$gptWindowsLabel.Location = New-Object System.Drawing.Size(220,210) 
$gptWindowsLabel.size     = New-Object System.Drawing.Size(80,20) 
$gptWindowsLabel.Text     = "Windows:"
$gptWindowsLabel.Visible  = $False

# GPT Windows Text Box
$gptWindowsTextbox          = New-Object System.Windows.Forms.TextBox
$gptWindowsTextbox.Location = New-Object System.Drawing.Size(315,210)
$gptWindowsTextbox.Size     = New-Object System.Drawing.Size(70,20)
$gptWindowsTextbox.Text     = "XXXXXX"
$gptWindowsTextbox.ReadOnly = $True
$gptWindowsTextbox.Visible  = $False

#  GPT Recovery Label
$gptRecoveryLabel          = New-Object System.Windows.Forms.Label
$gptRecoveryLabel.Location = New-Object System.Drawing.Size(220,240) 
$gptRecoveryLabel.size     = New-Object System.Drawing.Size(80,20) 
$gptRecoveryLabel.Text     = "Recovery:"
$gptRecoveryLabel.Visible  = $False

# GPT Recovery Text Box
$gptRecoveryTextbox          = New-Object System.Windows.Forms.TextBox
$gptRecoveryTextbox.Location = New-Object System.Drawing.Size(315,240)
$gptRecoveryTextbox.Size     = New-Object System.Drawing.Size(70,20)
$gptRecoveryTextbox.Text     = 15000

$gptRecoveryTextbox.Add_TextChanged(
{
    $this.Text = $this.Text -replace '\D'
    $Script:mbrSystem =  $this.Text
})
$gptRecoveryTextbox.Visible = $False

#..............................................................................
# --- End Of MBR and GPT ---
#..............................................................................

# Input PictureBox
$inputPicture           = New-Object System.Windows.Forms.PictureBox
$inputPicture.Location  = New-Object Drawing.Point 30,300
$inputPicture.Width     = "400"
$inputPicture.Height    = "200"
$inputPicture.BackColor = "Transparent"
$inputPicture.SizeMode  = "Normal" # "Zoom" , "AutoSize", "CenterImage", "Normal"

# groupBox for BIOS / MBR
$groupBox           = New-Object System.Windows.Forms.GroupBox
$groupBox.Location  = '440, 20'
$groupBox.Name      = "groupButton"
$groupBox.Size      = '400, 420'
$groupBox.TabStop   = $False
$groupBox.BackColor = "Transparent"
$groupBox.Text      = "Select BIOS/UEFI Partitions:"

# Button to exit form
$buttonExit           = New-Object System.Windows.Forms.Button
$buttonExit.BackColor = "ButtonFace"
$buttonExit.Location  = New-Object System.Drawing.Size(280,410)
$buttonExit.Size      = New-Object System.Drawing.Size(120,25)
$buttonExit.TabIndex  = 3
$buttonExit.Text      = “Exit”

$objToolTipInfo.SetToolTip($buttonExit, "Exit this application")

$buttonExit.Add_Click({do_Exit})

$groupBox.Controls.Add($radioButtonOne          )
$groupBox.Controls.Add($radioButtonTwo          )
$groupBox.Controls.Add($radioButtonThree        )
$groupBox.Controls.Add($radioButtonFour         )
$groupBox.Controls.Add($radioButtonFive         )
                                                
$groupBox.Controls.Add($MbrSystemLabel          )
$groupBox.Controls.Add($MbrWindowsLabel         )
$groupBox.Controls.Add($MbrRecoveryLabel        )
                                                
$groupBox.Controls.Add($systemTextbox           )
$groupBox.Controls.Add($windowsTextbox          )
$groupBox.Controls.Add($recoveryTextbox         )
                                                
$groupBox.Controls.Add($gptWinRELabel           )
$groupBox.Controls.Add($gptSystemLabel          )
$groupBox.Controls.Add($gptMSRLabel             )
$groupBox.Controls.Add($gptWindowsLabel         )
$groupBox.Controls.Add($gptRecoveryLabel        )
                                                
$groupBox.Controls.Add($gptWinRETextbox         )
$groupBox.Controls.Add($systemGPTTextbox        )
$groupBox.Controls.Add($gptMSRTextbox           )
$groupBox.Controls.Add($gptWindowsTextbox       )
$groupBox.Controls.Add($gptRecoveryTextbox      )

$groupBox.Controls.Add($inputPicture            )
$objFormatHardDrive.Controls.Add($buttonClearRTB)
$objFormatHardDrive.Controls.Add($buttonExit    )
$objFormatHardDrive.Controls.Add($groupBox      )
    
$objFormatHardDrive.Add_Shown({$objFormatHardDrive.Activate()})
[void] $objFormatHardDrive.ShowDialog()
