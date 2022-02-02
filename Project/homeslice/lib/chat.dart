/* implementation of chat using Firebase
*  Last updated 2021-11-16 by Tom
*
* Includes:
* Unmatch_User
* Open_Chat
* Send_Message
* Recieve_Message
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'conversation.dart';
import 'chat_database.dart';

class Messages extends StatefulWidget {
  var conversations; // pass in conversation tiles
  Messages({required this.conversations});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  // var conversations = [
  //   // note these conversation tiles are only for testing and should be passed in to the messages widget
  //   new ConversationTile(
  //     name: "Johnny",
  //     imageUrl:
  //         "data:image/jpeg;base64,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",
  //     time: "4:20",
  //     isMessageRead: false,
  //     messageText: "Howdy",
  //   ),
  //   new ConversationTile(
  //       name: "Aang",
  //       messageText: "When the world needed me most, I vanished",
  //       imageUrl:
  //           "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBxMSEhUSExIWFRUXFRUXFRcXFRUVFRYYFxcXFxcVFRcYHSggGBolHRUVITEhJSkrLi4uGB8zODMtNygtLisBCgoKDg0OGhAQGi0lICUtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLf/AABEIAKIBNgMBIgACEQEDEQH/xAAcAAAABwEBAAAAAAAAAAAAAAAAAQIDBAUGBwj/xABIEAACAAMFBAcFBgMFBwUBAAABAgADEQQSITFBBQZRYRMiMnGBkaFCUrHB0QcUYoLh8CNykiRzorLxJTNDZHSzwjREU2OjFf/EABsBAAEFAQEAAAAAAAAAAAAAAAQAAQIDBQYH/8QANhEAAQMCAwQKAgIBBAMAAAAAAQACAwQREiExQVFhkQUiMnGBobHB0fAT4RTxMyNCUuI0YpL/2gAMAwEAAhEDEQA/AKvaUzrlxr2hx/EOfxhtWBFRiIamNWGlJU1AqDmPmOfxi7pHo38n+pF2to3/AL9e/Unovpb8NoZj1dh/4/8AX07lJMKEMrPBxFT4QTTjohPpHNrq7p6kEYY6V/c9YImbwX9+MPZNdP0gRHuTfeA/fdBGTMOczy/SFlvTXO5STBUiN91Ort5n6wb2UGlScIWSbPcnmpkYmWRyygjEitafhrU+lYrBYl5xY7Gm9DMBXIG9Tjow8QQPOJtO5CVjLsDt3of3ZdK2ZaullI+pGPeMD6gxz3fbZf3ed0iqejmkkUyV82XlXMePCNvsSR0d5BjLakyUeTZqeYw76xK2ps9LRKaVMFVYeIIxDDmDFdJVupJsTNDke7u4fI2rPqKds8eF33+1xs2oe6fGn1hJtvIf1fpFhbdn9DMeUyreQ0NAMQRUMORBBhsLHYsZM9oc2UWOYs35K51zog4gsN+J/Sgm2McgPU/OEma508lPzrFlDbCJ/gl2ynkAl+WMaRjzKr7z/i/pA+IgXX/F/UB84mmABEf4l9ZH/wD1+kv5G5jeSg9C3A+LV+ZgfdG4L5/pFhSGHtQGXW7svP6RB9LAwYnuPi4qTaiVxswDwAUcWRvwjxP0hqeLoxYV4Ba/OHWmM2GfJfmfrDc+y4VY00CjjzPDugMsicP9KPL/AJOJA9bn7kiQ+RptI/PcAL+nyo1jGZ5juNOPwiQc8BQEigqWzoKVzOP7MJRKCggNSmOUZ5NyjQLJ6zWcvMWX2SWoa4FRmxxyIAJi72hJIYNduowUS6aKowU8DSppwPIxnZcxib1SMxiSWoVKkY5ChIjXbJ2itoQypvbp3XgPaHBh+o5XQTfheHWv8KqWP8rMN1Wy0rGh2Pu48wiooIkbu7DDTCrGpGI/EvHvGvhxjpGz7CEAwjYfVNIuwrMbTuBs5RNjbDWWBQRorNJpByUpD6wC95OqKDQNEoCDghArFSkjgQktBBoSSDNCQIOAsSSSSIEKgQky85mEw66QQlkxvLKTaGhqMtR8xziSpqKwJVlMTG2cQt5c8yvHu4H4xz1dQF7i+MZ7t/dx9e/Xpujuk2xMDJTloDu/Xp3aQ4OADXEQUYS6bVKhJECDhJiEhoICFMIFISZFBE0o3A18NfSsKpES32sSxxY5D5nlEmAlwAVcuHAcWi6TunbL8oyycUOH8pxHzHlF5HFt3dpzpbDo5hyoVvCpXDEBsPKN1JS2TlGL3GGZZFFDxu9bwpEJ6bC69xZZsVnDUffBV2+UtJ1oqh6yywLwyJVjVTxHWUV5cozcpq4EUIzHfkRxEXjSSjsrdpGKmmQplTlSh8fAVc6V1joQTQ+7XHxFKYRqUNcaazTmz7mPuffZV1nRbKiMOYetsO/gfbdxF0jo4aZYW9p0bqn0PMHWIk22+6PE5eAzPpHRmqhDA/ELHTj4arl/48uMsLTca8PbxTpFIjzLUB2RXnkP1hPQO+LevyWJEuyqOZ5/SK8c8vYGEb3a+A+VLBEztnEdw08T8KHdZ+Y8l/X1h9LGNTXlkP1ifZbK81rktGduCitOZ0A5mL6VuTaiKno15M5qO+6pHrFTm00LrzPu7/2N/LYrGunlFom2HAe6zAWmAFIgTpl410yH18fpGt2puZa1QkKjjW64rTWl8CMpabM8s3XRkPBgRXu4+ED1tW2RobEbjaR5BXUtOWOu/I7B7piDeVgrHKuA44Z/SHZEkuaaa/TxiTtKUQqmlBep/hMDxU94Xyu3G3z8K6Sa0rYxvz+FCMuiq3G8D/USPnDcuYQaioKnAjDmCI1m7+7T2mQaClVa4fxBiV8KgRXbubP+8mZZspjIXk1wpMl4mWeF5S1eBRTpCqYwHNttaOYCUMhs6+wnldXWwNs9LTrXZydYEa09tfOhHPgY6tu1tVbQmNBMUC+v/kv4T6Zd/ncM0tqiqspPJlYGhw8wR3xuN29vlirobk5PJhrhqh1GnkYoY/D3K57A7vXbYcEVOwtsJaZd9cGGDpXFT81Oh17wQLMtBN7oUiyMtBFoSIWBCSQgqQdIMQ6ZIhwQ20BTCTpRgQCYEJJcHWzViTJsgh5VhM2ZSNslZNkbBRDL2nCGJ06I5MMG53UsRtZJtOZZfzDjzHP4whSCKiFMYaaWQby56jRvoef7GV0h0aJbyRdraN/weXFbXRfS5gtFN2Nh2t+Rwzts3JUCAjg5eI1B4EQdI5ogg2IXXggi4NwhAgQUJKyRaJgRSxyA/YjMzJhYljmYv9prWU3cD5EH5RnoNpQLE7Vm1pOIN2WT9gmXZik5VAPccPnXwjpO7e2jLPRTW6nssfZ4VOg/14xy+LjZ212rdfrE9igxJ0U048YlURfkCBzBuFptoWkTLXPZcV6gqMiRXEeFD4iK/aiNS8oxyPdofAn1iTZJNxaZnNjxY5mHiIFNtB3LbijLYw06rPGxlu2fr56QcuUJemHvajk3Dvy7tZs9Lpp4ju/T6QkRbT1L6d+JvLf8d4QtXRx1LMLtd+757vRMmLDYGyWtU3o1wUYzH90cB+I6ecVzSyvZxFQLp0rgKHhy+EdU3W2WLPZ1X2mF5zqScf2O+Nqo6VaYbxdo+X3YVzbOi3xzYZdBnlt9+f7U+wWGXJQS5SBVHDMnixzJ5mDtNpCdoGh1AwiHtPZsyebpnvLl+7Kort/NMNcOQA510gytlzLOwAmzJ1nchXSYb7yyTRZks07INKjQEnGMRgbiu/Pf/e9aT8WGzclPtlvRkIU4nClD4xVCyJNIlzEDqSKgj1HA8xC7RJKMVP8AqOMCTMusGGhjdihYyIiPQ+4WJJM98oMmy3kVVz90lkNSWKy2bAnFlJyVjrwB7hnStVvrsgyrMjnMzlHmkw/KOh2e0LNUimmK/SM39p2Oz5de0tqVWPH+FNIPiCp8YEZUyfjdDIMwPL7zRjoGY2yxm4J8/uzYrrcWzBbBZ2pmlfNiY55vOhsG0+mUdW+s9QBmGJ6RfE9IO5hHTt0V/wBnWT+5U/OMz9qey79nWeBjKeh/kmUU/wCK56xJ4uy+5RYQH235Kr+0/d4Ai3yRVJl0TaZBjS5N7mwB504mMrsrZxmymez1E+QL7SxiXlZdLKGpWtGXUFSMSQeobg2tLVs4SpgDhA0iYp1UDqg/kZceIjnFts87ZVuBUmstr8tjlMlmoo1OIqp4GtNIreB2thU2E9naFfbrbwtUTZZAmKOuteqynTmp46H16zsjaKWiWJidzKe0jaq3P4ggjAxyvejd4PLXa2zuwwvzZYHYPtsFGgNQ66UJ40VupvIVYTZeYoJsuuDDh8SraeYMQ4sNjoncA8XGq7EIVWIlgtqTpazJZqp8wdVI0I4RIrBOqoRkwRMAmGi0JMlsYQGhN6Beh0kovAiO7wIdJchZ4YmmFmG2EbSydVHYQgiJV2G2lw6SaSXWFvKpFjYrN1awzaxpEb5qQCqp0vGowb0PI8vhBy3ryIzGq/pziRchudLB7xkRmP05RnV/R7agY25OG3fwPz6rV6L6TfTOEbs2E6buI+PHI5psQIaeaVwIqTgCMjy5GEGU7do3RwHzjl3scw2cLLso5WyNxMN/vklzrSowzPAY+B4RnJ8oqxBFNRXhpGllSFXIRH2pIVkJJoRkfl4xbBJgdwKpqYS9t9oWeMaPYGzbv8VxiR1RwB1PMwzsbZOUyYOaj5mNBF00t+qFTS09rPd4fPwhBwUAGBkeoG20/h3gaFSCCM+HziTu7s4FOntTN0RJEtFA6SaR2iMqIMq6nUawbfalmsshT23RWYZCrAYcc6+EbHeCYsljKRF7AF4gG5LAupLlg4KABUni0XNHVAI/pZlXNhd1CmbTu8gtcjox/BmC8MSaEAEipxoVNRXnwjaWq0pLRpkxgiKCWZjRQBqTEDd1SbPKvrQgG7XhVgp/pMFtCxdParLKdSZQ6Wc49lnldGJSsNcZjNQ+5XSGa3E4MQUkpDS85pVi2s04XpdktLS9JhSXLDDiqTXWYR+WJ1mtKzBeUnOhBBVlIzVlYAqcRgRrDG197OitSWOTIefNalQGWWq1W9dvNm13rUwFKYxNtKAus0KVLyyHU0rVCtA1CReW864Z8SAIvmp2tbdqHiqHOcA5QNp2UuAVFSMPCIp2ddW815j7iCpPKpoPOg5xcQIg2rlYwMabDzVj6SNz8ZGazybX6EjprG8mWSB0pZJgWuA6QoTdGWNTFf8Aagf7Ko4zpZ/pScCf8a+Ua6fKV1ZGFVYFWByIIoRGP+0OzlbCgJvdG8lST7VVcV//AD9YZjsT77c952cU724W22Zeq2O6Sf7Nsh/5eV/lBgW+Qs+XMkt2XRkP5gRXvGcK3Tb/AGdZB/y0n/IsLIxjUZmFmu1XNvsvtbSbXNsj4FwRT/7JJNQO9b/9Ija77bs/fbMQoHTS6tKPE+1LJ4MAPEKdIxG/Eo2HaMq1qMGKzaDVkIWao71u/wBZjrcqaGAZTUEAg8QRUHyitgyLDsU36hwXKfsn3k6CcbHNNEmt1L2FydldIOV6lKe8BxMSd/8Ac9rI5t1jFJdazZYGEuubAD/hHUeznl2Y32qbu9FM++SgQkxgJtKi5N0cUyvcfeHFo2+4284ttlBcjpk6k4cTTB6cGGPCt4aREN/2HwUif948VlN0d5rh6RKlTQTpdcf5l/ENDqMD+Hp0m2K6h0YFWFQRqI5Fvlu21hmG12UfwSf4kvSXU5f3ZOXunlSljuvvJdF5amUx66ZsjasBx4jUYjHNmOwHC77+k724xib9/a6d00I6SKxLYGAZSCCKgjEEHIiHBaBBNlRdTr0JeZEJrTEd7TD4UxKnPOgorTOgROya651SCKw5dgqRrLKTdIfs9mvQqXKidLIURFxUgEJ5CJFJPmw/tC0XjyiCRCYNqRKQTBEQoCDpEiLiyTTYgpu4CKEVEJKleJHHMjv4jnn8YfAg6wLPRxzxhjxpodoRdPXy08pkjOuo2Hv+3GxRwYitLEycqN2VW9Tif384lzF1XxGh+h5xGtEktRlN11y+jcuffHNz0clI/r6HR33Qrr6WvjrWdXtDMt+N/wBvZWsLWKyx7SvG46lX8we6LFWrkawOWkLQa8P0KVAgQIinWTtC3JjAGl1jQjShwI9I6hssydpylmklJyqEmhSMCKkEgg1U1JB5kVww5jtBqzXI94+mES9iS+szaAU5GuJr5esFu7N1jzAZldqskm4iJeLXVVbxzNBSph5DQg6g1HkR8CYq92pl6yyCP/jUeWHyhdn21Jd5ssP1pLBJlVYKpIvDrEXcjxgcB18tiou21jtVLtnd6e9r+9SJiS3EwOjlmvSyZYlv1QtHBAOBOtI1Sk3VUkm6oFSasx1ZjQVJOJwhmZNJQtLoxobuIIJ84ORMrgQwIAqWFK8wRhEnSveLFRbCxhuAnHYAEkgAAkljRQAKksdAAK1iBsSfZbcGPRTXUNQTJqNLRyBU9CL1UpzAbDXOHdp2fppUyUHulhStK544jUHI8iYr9yNkz7MZgnTgJKvMeXLLK3XmGrzC90EKKsAv4iTTCL6bBnfVUVOM2top9mXoZsyzlmZUVJktnJZuje8LrOcWKsjipxulakmpNH9ojf7PpqZ0t25YEKvI0pXnWLLatqDzy9HKmWZaKqm/MVGvzHGRCklFBNMLxriIz2+dslvYXAbrFpEwIzVmKrYYgmpowcekSAaHvtu/tNdxa2+/+vJbjdNaWCy/9NJ/7axK6PHGG91E/sVm/wCnk/8AbWJM9cYPagzqsn9pmzOmsTOB1pJE0fyjCZ4XSW/KIP7N9qdLYUUnrSSZR7loU/wFR4GNJMAZSrCoIII0IIoR5RzHcaYbHbp9jY4NVVqczLqyN+aWxPlEDk8HfkpDNhG7NdI2hISdLeVMF5HUqw5HgdDqDoQI5BY50zZNvKtVkGD0/wCJJY4OB7wpXvVhxjrBmxmd+Nj/AHqTeUfxZdSnFh7UvxphzA4mJSMJFxqE0b7ZHRaR56utRRkZcNVZWHqCDHMt4djPYZn3iRjIY0Zfcqeyfw8G0y7524G3SV+6ucVq0qvu5snhmOVeEa2dRgVYAgggg4gg5gjhD2ErLprmNyoN39uAKCDWUxxGsttcNBxHjxrpfvEc42ts97BN6WXVpDGhFez+Fj/lbwPO/wBjbTBTqkspVjLVe1eAr0eRoDlShoeVKVNlMfVfsVjo8fWatOZxgr8QdmI5ZntEkJLpRA1G5ktWrA5ihoMMBU4vyWIABDA0yYEGmla5nKvOJxTiRxAHp99VGSEsAJUm/AhmsCClQsmFhQSHrsMzplI0Vm2Si4WI06eTDbvDZhwErpLGGysONB0h0kzdgGHiITchJk3BXYeuQZlwkkwVhLSAe/QjMd30iV0NYdEuIOaHHMX2c9Va15aOqbG9+WizW2FKspPa0YagZVGhB+fdFyJd4BjVWIFSpocsufjWKjbyFZoYioIUjh1cCP3xi7luGAYZEAjxjl61jY5C1gsB95bty7XoyR00Ie83JGfn5hR36ZezdmDn1W9MD6RWWy1z6UKlBrQH/NjF7BwK19tgR74yRk4/fPzWNBi72Uv8Ific1+H/AI0hG3bKBRwKVND8QfjBbHm1Vk1BvDuw+Y9YIJxMusypYW5Lou41sqjyTmjXl/lfH0a95iMvvFtebs3aNpaWoYWlJMxa1orKrSyVFKGpU18IGzLcZMxJy407QHtIcx8COYjSb42JJ0qVakowTEkaynoSe4EA916IROwPB35IQsDxhKzth+1Mg/2mwyZjE/7yWTJcDkCGNc8QwjUbH34sFpIQTXsznAJaADLPITATn+JvCM/MsyMKFFI4ECkZreDYCohnSRQp1mQ4qQMTQH4ZEQSXNf2gpvojGCWHl8Ls4kdHQFQobslTVGoMAp7hlQcoXHP9zltm0Jct7URLsiusxJaBlM90N5GNWJWUrAMAKAnlGt25tQSEwFWYgAA0oDUlq6YA05+MCTNaHWaVGAvcMxnsWe21ammWxRLJqjKiEe8DVj3VJB5LGd36ZXmMM7gRDyYVZgCNQXI8DFttHazNX7vLl2ckULhQ0yn4Wwu99CYxs/Zs5a0qwJqSManiQcawsnAAGyMhgfG4ue3et7urvy9nly5M9eklKqqrLQTEUAAAg0DgDuOHtGN5YdqSbSt+TMDjUDBl5MpxU94jg0u3ilCCDyoREuxW43w0ouJgyK1Vh+YZDxi6OolZ2xcKqeghkzjOE7tnyPDLgu3TMI5t9oMoyLVItqDUBqatLNQO9kJHcsT9n72WlFAndHNpmSCrU4FlwrzuwW8O05Nus7yVR+lwaWAAwLrkoYHCovCppQEwUZ43tNjY658PJAOop4iC5uXDP9+S0AmhgGBqCAQeIIqDCGeK7d+zT5dnSXNlm8gK4NLIug9X2tBQeESJpf3H/pJ/y1i1tVC4ZPHMIQwyDYeSxG9+z2s89bVJ6oZr2HsTM/JsT/VxjV7K2mtolLNXCuDD3WGa/vQiDttl6VGlvLe6woeo/gRhmDQ+EY+wpaLCZl+W4lNVA9CBfoejdQccdRw7ogJGNfkRY8Rr3KeBzm5g3HA6LSbetSdEyVVi1KrUE3cz1eBCkeMObgyTLvqii7dBc+0WxpQ6658IzrWYic7k1DBbn8pANPCgX8pjebsSRLs4Y5uSx4nGigeAHnAlRN+Rt0VBHgOaKRthJ6TB2WlzACjNdfqMCctaqww1GcSLdKLYoBSWrCmVeySq6Cl2nfhpGYk2qdYpxW03UkT50yaZygsQzAt0RYZYgAGlaVpyv7BbxaQRJBWRdNZmALMfZUHEHGpJx7jFNzG7E3YrCMYwuTYMHDEtqop4gHzEFG/ZYqpZsymUQ5jViVaJRERSI0QgCm4TSHaQVIkmSKQoJC1SFEwydIu0iBbVIcMGZai7gcARUjqnDHEeUTiYYmSw1Qciv7pzimojMkZaDY7DuOxX00oilD3AOA1B2jaOSjraXXMAjiOq3kcD6RIl2xGwrQ8G6p9cD4RFFQSpzHqNGHf8awTgHMVjnmdKVMLiyUA21vrzHuDddTJ0LR1DBJCS2+YtmOR08CLcFcS0rDolxRSiy9lyvLNfI5Q9I2pNChpkqoIxaXjQ5EFTiKEHWNam6QjnBsCLa7fT3A42WHW9Fy0pFyCDpbL19ieCk7UsSzVunA5g8DxiosFoMo9DNw906Dx4RbSdoSpnZcV4HA+RzgrVY1mC6ww04g8QYlU0rKll2nPfsUaGvko32Iy2j4RQYiCkibJwH8WXwydfr+8oky7QpwrQ+6wKt5HGOemppYT1x47Oei7CmroKgXjcL7tvLVC3WfpEK66d4yjMSpjI1RgQcj6gxrogbQ2WJnWGDeh7/rEI3gZHRSnhLxcJ6wMs2XelmpXtp7SjiOK/Duyvt29uiRWVMxlNUg0vXCc8Bmh5ZHkcMEZc2S4IvI4PVKnHwIiVatszGZSyhWWt+6CvSVpiy5A4acaxMx3OWYKynROabLpf/wDClTRes85QhyAAmKOSkMKDka0g12NZ5QraJqsNVa6iHkVJJburQ8Ip7Ju5LnIs1ZykMoIqgJFdO1ES1WSyyP8AeWpRTNUUM/ddUtTvMUCa5sCeWfonxyWtsWinbxmYwk2VLzHC+wIRR713Og500zip29a1ZhLV7/R1vvh1pmAJNMKilMMBUjClIpDtxpgMqyoZEr25laz35XvZ1yy4jKG+jYAKl1FAoPaPlgB6wi03zy4fKLpYiDjd4J+ZMCirEAcTFPatpNM6klSdCww8joOcTRs1K1esw8XNR4LkPKJEycqDEhRpkPKJNwjijH4iMzhG3fz0CqrLsPWa35VwHi30pFrZZVSsuUgFTQUFPIfMxCmbRlazF7ga/DMwmXtuUrBlmEEYghWw9ImQ933JZ76kNyiHjtWyfYiWeS81gJk0AUJFVUkgVUHOla4+Qh/dGSKTH9q9drmaUDHzLY9wiolbzmYhlzbrqwpUdR+RplUYHKGtk7xJZnKzKhGz6p09paVrzGfzE/HIWkHX2TMe0sIGuXeR/a31YEUjbz2a7eVy4/Cp+LUEU1s3yJwlKAOOLn06o9YHELzs5qOMaDPuWwnTlUVYgDnGG3+tKz0liUWJRmYi6QDUAVFcyMfMxDnbw2hvbYfmu+iD5xBmWuYxqWBPE3ifMtBEUf43YidPu5SMcrtG87D3TmzdorNUKxo65cOY7q48jXjWOk7Edegl1YVVADjlX9599I43b715XKqcQSUqjGhyJJNKjXONZZ9p2a4AOlVcwCA9Cc6EXiMsccdYOwB7cnAd5shXtex3+N3gL+i2O3Glz5ZkGjq1L5BwFDUAEe1UaZcjSMHaJ0/Z/wDALFrK7EggUOIxUkZHDFcjmNaXVk23Z0W7ffU1Mt6mprotIVa9qWSahSY15TmOjmeY6tQRxg1kMP48OIX11GqBc6fHcsdbdY/CkbP2mrKL7jKqubtGHjk3L9QBGFFtayuyyv4so4qSrr8qg6HQ5wIX8tzcjY+ITmiLswDyK3dpSsQ/u1YsilVERjhG6CVhkKA0mkIuRKnQwREwVAphzDZMSylRDYkw6VkwFhayolJJhiTIefN6FTdUdojgO1jwxApxzwiioqWQR436K6CB0z8DUzbZApUsFIyJIAPFTyP0irD3sgfHqfHHyEdCs2wbOmUpSeLCpPfXCJpkpSl1acLo+EcnW9IR1Dw4Mse/XvXU0Mc1LGYw+4PDTuudv3U35ldb8I8CfWoh+yzGSooCCaihoQdaYa4HvrxjfTbIp7MmXXiyr50Ax8xEF93kc1mOT+GWqSk9AW/xRVT1v4X42ZHn5KVSx1QzBIbjksXbElPi8siuvVB9Dj41iNLWYhHRTGK8Ji0p4HPwpHR5GwrOmUlSeLVc+bExmd6JaLOCSkAN1RdUUqxJoKDlSDB0q+V2TQDvzB8nZ+NxwQP8BjBmTbdkR6ellVLaZhwN0HVlr5AEYHxMR5k4zBMvdYLVBWhyW8dOLEeEX+1NjizyZZOLs3XOlaVoBw+kZzYSdJMazkgMztQnAGufw9YZ1ZJM0lzrge21TZSsjPVbn8qUJSjIAd2ETbJsmZN7EtiOJwXzOEandyxoJSlpa9IpZXJAJvKxBxPdXxi6jPfUkEgBFtYSNVnNnbqquM0gn3VwXxOZ9Iym8GxF+8zrpu9cUFMBVEbDhnHToxe8aUtL/iCN4XQvxQwoJnl5JOxEwRtL7W3rHnYj8V8z9IdkbDp2m8FHzP0i5rAYgZmkF/mfvRn8eMZ2TcmSqC6ooIdhg2oez1u7Lz+kMTJhbPLgPnxiom2qtGmSY2ltpJdVWjN/hHefkPSM9PmPMN9qtzoaDkKZCNEkhVyVR3ACE2o9UxY2cN0ahpad0nadluAVNJ2a7Z0Uc8/IRY2bZ6Jj2jxOncNIlqMBB0iL5nuUo6aNmep4/bImxht5IIocuFTTyh2kCKgSNFa5gdqLqM1jShAUCvLGumMJsUyq04YeGn08IlRCXqzaaN/qPmPGH11USMOimQIECIqSRMQMKGIlkcqSh8O+J0RLbJqLwzHwh0xG1S4EMWWdeXmMD9fGHociyQN0REHBwIayS305sKRDYw7MeGDHbALzolNvCHWFmG5swKKsQBxJoIdRSBCZ09Ja33YKOJNPAcTyipt+2TlJUE+89QB3KMT40iin2YzGvTXZ254AcgBkO6A5q2NuTcz5LQg6Olfm7IefJWG0N7qm7Z0qSaBnGZOV1fr5RttzJFJTOTVmajHU0AJPKpYmOWWizdEyzFrQMCRnShr5R0TdrbUuUDLmMFDG8rE4YgCh8hjGF0lLJMwbeC1qaBkDrALYwIblTVYXlYMOIII8xDkYS0UmCMLgQrpJIjM2az39ouxyQXvG6qj4gxpYYk2QLMebq4Uf0j5/IRYx2EHiLKDm3so28Vk6SQwAqV6w8Mx5ExzTacggichIZaEkZ4ZMOY+HdHXoy23d36VmSRUZsmo4leI5eUX002DIqD2m9wnNz9tC0qxwEzDpVHvAUE1R7rAAHgV5xpY5A0qZZ5gnWclSOGnEU9pTw/Y2OxN+ZMxQJ9JT6nEyzzBzHcfOHnpz2mZjzCdjhZa6IG0dkS55DNeDAUqpoaVJpjUZk6axGnb02NBU2hDyW858lBMNWLeqTOZVlLMa8wUG7dWvexrQa0EUsilv1WlSLw0YrrPWzZjC0NIl33NRdGFSCAakigAFc8om27cueqBwVdvalg9bwdsG7sO8xstnyhLvsQL7tViMcBgq1OgAHjU6xL6eN+Gk6g/JrbksuSseX3abgHbnfwK5E6kEqQQwwIIII5EHEQgx0XbtjlT+qyXn9lhgy/m4cjgeEZHaW782T1h/ETUqOsP5l171r3CA5qJ7M2Zjz/fgtmm6UjkAEnVPl+vHmqcwzbDRDEgUOIxiNb+wYEGa0naJ8QqEwISSFIKFQISZIpEW3JgGGYP+nrEwiEzEqCOMODZMRcZpKNUAjUVg4j2FsCOB+P61iTCOqYG4RQIIwVYZJQzLKPUZHPu/SJlYIwlXFaQ90wFkqBB0gQk6lSt9BTrSTX8Lgj1ApE8bwoRUS28xSMFFls9+pjoSPn843P5swGvkFykdFC42IPNX20d43CEogU8Sb1MaVpQRVS7SZoDMxZsjXQ6gcByhufPUKSSCMqVz5Qrd3YL2nrlzLk3qEDtTAMwG0GlacYjimqDhJv6K0thpOsB7nwRiZU3VDO3BFLEd9MvGJMuw2g/+3cDm0sehasbKVZVlqERQqjIAUEKIgxvR7LdYkoJ/Skl+qABz+FkW2DPcFTcQHAktePgqinrD0zdNSgUzCzDJmUEAe7QUN3kSY09IFIvbSQtFrIZ9bO83LuQUOx2NZSqqC7QAVXqsaakrSLGTtCavt1/mF71FD6wwRCCIslpoZe2wHw99VTHPJGbscR4/QlzrTMbN2Pcbo8loIZQt7zDuZgfQwqkOyZVTDtgia3CGgDuCYyyONy48yrLZomEYzGpzofUgmKO3b7GVOeWZIdVIF68ZbHnQg4c8MjGxsNn6tMoibwWGyMFNoEsKhF1nYJShrS8SKg0xGR1jJqaOGQ9VoHcLellp09RIwZuJ8VW7P3qkzALwaUcuuBQd5Bw440i+rB2zYNntksXxRqUWalL1DoTk68jUcKZxTbvWk3XkM195Ex5RbK8EZkDU0xU4d0YlZRfh6w0utWCpbLYAWO35HxsRbU3eSa19TcY9qgqDzpUY84r23Kltizgn+7WvqY1FYbtNoWWpdjQD9gAamBGzSDIFXFjdSFnZm6VjlKXmCoGZN0eAuip7oLdTaNlmu4lyxLdCQgOJKZX1bU0zHs15kmt3ltk1yC6lAR/DU544XiOPyEU1CCrISrLQqwzFMoPp5TE4Pf1j6d3FMKQ1DXBptbzPHguoPNhDTucUGxNudOLj0Wao6w0Ye8vLlp5RZVjoGOa9oc05FYMjHRuLHCxCfMymUNPOJhJhJiVlEqt2jsiXNq3Yc+0uv8wybvz5xltr2GZKU3lqMOuuK566r4+Zjbu8R5hgeakjlzOR3j33+KLp+kJqfIG7dx08N3pwWNMFF7a9kK1SnUPClUP5dPCnjFTabM0vtrQe8MV89PGkZM9FLFna43j3Go9OK6Cm6ShnsL2duPsdD68ExBwGgoFR6VCYBMJhKKZCUcka/v8AffDhgrRUCsKlmoB4isOmREQKQqkCkMlZIpEa2SyKONP3WJkJIhxkmISJcy8AQK/KBES+ZTHCoP7rAh7KOO2RWcsjGhxgy5pmczrzgQI1tpXMsThjp+7I/s8n+7ECBGhR6uQtfo3xVq8NmBAg5ZSSIMwIEOkm4AgQIdJCJmz+1AgRF+ik3VaGTHEN+prNtCfeJN1lVakm6t0G6K5DlBwIy6jRa9L2vBdO+yhz9wXE4TJoGOQvHAcIptzj/a7V/f2v/vwIEA13/join/zH7tW0hmd25f5j48YECOeWqVkt8/8A1C/yD4tFEIOBBQ7Le75RtJ2D3lCtJ0kjA3xiMOEbowIEbfRv+J3f7BYnTf8Amb3e5QaEtAgRorGTBhMyBAiSimjBNAgQhqou7JWRtYpMmqMAGFAMAOqMhpBwIEcxP/ld3ruKb/CzuCBgQIEVK9Jndk9xhqwdgd7/AOYwIES2KLu0Pu5PQDAgQydFAgQISYqJb8h3wIECGUV//9k=",
  //       time: "9:00",
  //       isMessageRead: true),
  //   new ConversationTile(
  //       name: "Slender Man",
  //       messageText: "Live with me",
  //       imageUrl:
  //           "data:image/jpeg;base64,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",
  //       time: "7:00",
  //       isMessageRead: false),
  // ];
  var conversations = [];

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Homeslice"),
        backgroundColor: Theme.of(context).primaryColor,
      ),

      // app body
      body: new Padding(
        padding: EdgeInsets.fromLTRB(50, 30, 50, 30),
        child: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new SizedBox(
                height: 20,
              ),
              new SizedBox(
                height: 300,
                child: new ListView.builder(
                  itemCount: conversations.length,
                  itemBuilder: (context, index) {
                    return new Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: conversations[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// widget used for each individual convo
class ConversationTile extends StatefulWidget {
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;
  bool tapFlag;
  String convoID; // pass in conversation ID here

  ConversationTile(
      {required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.time,
      required this.isMessageRead,
      this.convoID = "DUMMY STRING", // CHANGE THIS
      this.tapFlag = false});

  @override
  _ConversationState createState() => _ConversationState();
}

class _ConversationState extends State<ConversationTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          var messagesFromDatabase =
              []; // empty list that will hold Messages objects to be passed into the converation widget
          QuerySnapshot database_messages = await getMessages(
              "4JITZIL3sHHcwVVT9EYa"); // replace this with the line below
          //await getMessages(getConversation(currentUser, widget.name).toString()); // gets the messages for the given conversation

          database_messages.docs.forEach((res) {
            // loops through all the messages and creates the message widgets
            messagesFromDatabase.add(Message(
                messageText: res.get("message").toString(),
                time: res.get("time").toString(),
                type: "receiver"));
          });
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Conversation(
              name: widget.name,
              messageText: widget.messageText,
              imageUrl: widget.imageUrl,
              time: widget.time,
              convoID: "4JITZIL3sHHcwVVT9EYa",
              messages: messagesFromDatabase,
              //convoID: getConversation(currentUser, widget.name).toString(),
            );
          }));

          widget.tapFlag = true;
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: (widget.tapFlag ? Colors.grey[500] : Colors.grey[900]),
          ),
          padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
          child: Row(
            // two different row widgets are used to ensure popup menu is aligned properly
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // profile pic
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  // container with text
                  Container(
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.name,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.messageText,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[300],
                              fontWeight: widget.isMessageRead
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              // popup menu
              PopupMenuButton(
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            // delete from conversations
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.delete),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Delete Conversation"),
                            ],
                          ),
                        ),

                        // profile option
                        PopupMenuItem(
                          onTap: () {
                            // show profile
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.person),
                              SizedBox(
                                width: 10,
                              ),
                              Text("View Profile"),
                            ],
                          ),
                        ),

                        // add to group option
                        PopupMenuItem(
                          onTap: () {
                            // invite to group
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.group),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Invite to Group"),
                            ],
                          ),
                        ),

                        PopupMenuItem(
                          onTap: () {
                            // unmatch user
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.block),
                              SizedBox(
                                width: 10,
                              ),
                              Text("Unmatch User"),
                            ],
                          ),
                        ),
                      ]),
            ],
          ),
        ));
  }
}
