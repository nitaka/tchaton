<template>
  <div class="container">
    <h2 class="modif underlineHoverH2 fontColor" v-if="modePassword" @click="switchTo()">Modifer ton profil</h2>
    <h2 class="modif underlineHoverH2" v-if="!modePassword" @click="switchTo()">Modifer ton mot de passe</h2>
    <!-- Modif Form Change nom prénom + poste(metier)-->
    <form v-on:submit.prevent="modifier, changePassword">
      <h4 v-if="!modePassword">Changer nom de profil</h4>
      <input aria-label="Changer ton nom" type="text" id="nom" name="nom" placeholder="Ton nom" v-if="!modePassword"/>
      <input aria-label="Changer ton prénom" v-if="!modePassword" type="text" id="prenom" name="prenom" placeholder="Ton prenom"/>
      <p class="red app" v-if="long && !modePassword">Les champs doivent faire au moins 3 caractères.</p>
      <!-- Modif Form Change mot de passe-->
      <h4 v-if="modePassword">Changer mot de passe</h4>
      <input aria-label="Ancien mot de passe" v-if="modePassword" type="password" id="oldPassword" name="login" placeholder="Ancien mot de passe" required/>
      <input aria-label="Nouveau mot de passe" v-if="modePassword" type="password" id="password" name="login" placeholder="Nouveau mot de passe" required/>
      <p class="red" v-if="errorNewMdp && modePassword">
        Ton mot de passe doit contenir 8 caractères, une majuscule, une
        minuscule et un caractère spécial
      </p>
      <input class="buttonSub" v-if="!modePassword" @click="modifier()" type="submit" value="MODIFIER"/>
      <input class="buttonSub" v-if="modePassword" @click="changePassword()" type="submit" value="CHANGER MOT DE PASSE"/>
      <div class="alert alert-success app" role="alert" v-if="update">Utilisateur mis à jour !</div>
      <div class="alert alert-danger app" role="alert" v-if="errorMdp">Mot de passe incorrect !</div>
    </form>
    <div>
      <h2 class="suppr">SUPPRIMER LE PROFIL</h2>
      <!-- Modif Form supprime le compte -->
      <form v-on:submit.prevent="supprimerCompte()">
        <div class="alert alert-danger app" role="alert" v-if="errorMdp2">Mot de passe incorrect !</div>
        <input aria-label="Entrer mot de passe pour supprimer votre compte" type="text" id="password" name="login" placeholder="Mot de passe" required/><br />
        <button class="btn btn-danger mt-3 mb-5" @click="supprimerCompte()">SUPPRIMER</button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import router from '@/router/index.js';
const CryptoJS = require("crypto-js");

export default {
  data() {
    return {
      long: false,
      errorNewMdp: false,
      deleteAccount: false,
      oldPassword: null,
      modePassword: false,
      update: false,
      nom: null,
      prenom: null,
      password: null,
      image: null,
      errorMdp: false,
      errorMdp2: false,
      userId: document.cookie
        ? CryptoJS.AES.decrypt(
            document.cookie.split("; ")
            .find((row) => row.startsWith("userId="))
            .split("=")[1],
          this.$store.state.CryptoKey
          ).toString(CryptoJS.enc.Utf8)
        : null,
    };
  },
  methods: {

    supprimerCompte() {
      this.password = document.querySelector("#password")
        ? document.querySelector("#password").value
        : null;
      const self = this;
      self.errorMdp2 = false;
      axios.delete(`http://localhost:3000/api/user/delete/${this.userId}`,{
        data: { password: this.password } 
      },
      {
        headers: {
          Authorization: `Bearer ${this.token}`,
        },
      })
      .then(function (res) {
        console.log(res);
        document.cookie = "userId=";
        document.cookie = "user-token=";
        router.go("/");
      })
      .catch(function (error) {
        self.errorMdp2 = true;
        console.log(error);
      });
    },
    
    switchTo() {
      this.modePassword
        ? (this.modePassword = false)
        : (this.modePassword = true);
    },
    upload(event) {
      this.image = event.target.files[0];
    },
    changePassword() {
      this.password = document.querySelector("#password")
          ? document.querySelector("#password").value
      : null;
      this.oldPassword = document.querySelector("#oldPassword")
          ? document.querySelector("#oldPassword").value
      : null;
      this.token = document.cookie.split("; ").find((row) => row.startsWith("user-token=")).split("=")[1];
      let validPassword = new RegExp(/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$?%^&*.]).{8,}$/);
      if (validPassword.test(this.password)) {
        console.log(true);
        axios.put(`http://localhost:3000/api/user/modifPassword/${this.userId}`,{
          oldPassword: this.oldPassword,
          password: this.password,
        },
        {
          headers: {
            Authorization: `Bearer ${this.token}`,
          },
        })
        .then(function (res) {
          console.log(res);
          this.update = true;
        })
        .catch(function (error) {
          console.log(error);
          this.errorMdp = true;
          this.update = false;
        });
        alert("Mise à jour du mot de passe")
      } else {
        console.log(false);
        this.errorNewMdp = true;
        this.update = false;
      }
    },
    modifier() {
      this.nom = document.querySelector("#nom")
        ? document.querySelector("#nom").value
        : null;
      this.prenom = document.querySelector("#prenom")
        ? document.querySelector("#prenom").value
        : null;
      this.token = document.cookie.split("; ").find((row) => row.startsWith("user-token=")).split("=")[1];
      let validName = new RegExp(
        /^[a-zA-Z]+[a-zA-Z]+[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*){3,}$/
      );
      if ( validName.test(this.nom) || validName.test(this.prenom)) {
        axios.put(`http://localhost:3000/api/user/modifAccount/${this.userId}`,{
          prenom: this.prenom,
          nom: this.nom,
        },
        {
          headers: {
            Authorization: `Bearer ${this.token}`,
          },
        })
        .then(function (res) {
          console.log(res);
          this.update = true;
        })
        .catch(error => console.log(error));
        alert(`Félicitation ${this.nom} ${this.prenom} `);
      } else {
        this.long = true;
      }
    },
  },
  mounted() {
    if (!this.userId) {
      router.push("/");
    }
  },
};
</script>

<style scoped lang="scss" >
@keyframes disparition {
  100% {
    opacity: 0;
  }
}

h4 {
  margin-right: 200px;
  text-align: right;
}
.btn {
  margin-left: 25px;
}

.app {
  animation: disparition 3.5s forwards;
}
.red {
  color: red;
  margin: 0px;
}
.underlineHover {
  color: rgb(70, 23, 23);
  cursor: pointer;
}
.buttonSub {
  font-weight: bold;
  background-color: #005C8A !important;
}

#image {
  margin: 20px;
}
.modif {
  text-align: center;
  cursor: pointer;
  position: relative;
}
.container {
  margin-top: 50px;
}
.error {
  color: red;
  margin-top: -30px;
}
.signup {
  margin-top: 70px;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 550px;
}

a {
  color: #92badd;
  display: inline-block;
  text-decoration: none;
  font-weight: 400;
}

h2 {
  text-align: center;
  font-size: 16px;
  font-weight: 600;
  text-transform: uppercase;
  display: inline-block;
  margin: 40px 8px 10px 8px;
  color: #000000;
}

/* STRUCTURE */

.wrapper {
  display: flex;
  align-items: center;
  flex-direction: column;
  justify-content: center;
  width: 100%;
  min-height: 100%;
  padding: 20px;
}

#formContent {
  -webkit-border-radius: 10px 10px 10px 10px;
  border-radius: 10px 10px 10px 10px;
  background: #fff;
  padding: 30px;
  width: 90%;
  max-width: 450px;
  position: relative;
  padding: 0px;
  -webkit-box-shadow: 0 30px 60px 0 rgba(0, 0, 0, 0.3);
  box-shadow: 0 30px 60px 0 rgba(0, 0, 0, 0.3);
  text-align: center;
}

#formFooter {
  background-color: #f6f6f6;
  border-top: 1px solid #dce8f1;
  padding: 25px;
  text-align: center;
  -webkit-border-radius: 0 0 10px 10px;
  border-radius: 0 0 10px 10px;
}

/* TABS */

h2.inactive {
  color: #cccccc;
}

h2.active {
  color: #0d0d0d;
  border-bottom: 2px solid #5fbae9;
}

/* FORM TYPOGRAPHY*/

input[type="button"],
input[type="submit"],
input[type="reset"] {
  background-color: #56baed;
  border: none;
  color: white;
  padding: 15px 80px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  text-transform: uppercase;
  font-size: 13px;
  -webkit-box-shadow: 0 10px 30px 0 rgba(95, 186, 233, 0.4);
  box-shadow: 0 10px 30px 0 rgba(95, 186, 233, 0.4);
  -webkit-border-radius: 5px 5px 5px 5px;
  border-radius: 5px 5px 5px 5px;
  margin: 5px 20px 40px 20px;
  -webkit-transition: all 0.3s ease-in-out;
  -moz-transition: all 0.3s ease-in-out;
  -ms-transition: all 0.3s ease-in-out;
  -o-transition: all 0.3s ease-in-out;
  transition: all 0.3s ease-in-out;
}

input[type="button"]:hover,
input[type="submit"]:hover,
input[type="reset"]:hover {
  background-color: #091f43;
}

input[type="button"]:active,
input[type="submit"]:active,
input[type="reset"]:active {
  -moz-transform: scale(0.95);
  -webkit-transform: scale(0.95);
  -o-transform: scale(0.95);
  -ms-transform: scale(0.95);
  transform: scale(0.95);
}

input[type="text"],
input[type="password"] {
  background-color: #f6f6f6;
  border: none;
  color: #0d0d0d;
  padding: 15px 32px;
  text-align: center;
  text-decoration: none;
  display: inline-block;
  font-size: 16px;
  margin: 5px;
  width: 85%;
  border: 2px solid #f6f6f6;
  -webkit-transition: all 0.5s ease-in-out;
  -moz-transition: all 0.5s ease-in-out;
  -ms-transition: all 0.5s ease-in-out;
  -o-transition: all 0.5s ease-in-out;
  transition: all 0.5s ease-in-out;
  -webkit-border-radius: 5px 5px 5px 5px;
  border-radius: 5px 5px 5px 5px;
}

input[type="text"]:focus {
  background-color: #fff;
  border-bottom: 2px solid #5fbae9;
}

input[type="text"]:placeholder {
  color: #cccccc;
}

.fadeInDown {
  -webkit-animation-name: fadeInDown;
  animation-name: fadeInDown;
  -webkit-animation-duration: 1s;
  animation-duration: 1s;
  -webkit-animation-fill-mode: both;
  animation-fill-mode: both;
}

@-webkit-keyframes fadeInDown {
  0% {
    opacity: 0;
    -webkit-transform: translate3d(0, -100%, 0);
    transform: translate3d(0, -100%, 0);
  }
  100% {
    opacity: 1;
    -webkit-transform: none;
    transform: none;
  }
}

@keyframes fadeInDown {
  0% {
    opacity: 0;
    -webkit-transform: translate3d(0, -100%, 0);
    transform: translate3d(0, -100%, 0);
  }
  100% {
    opacity: 1;
    -webkit-transform: none;
    transform: none;
  }
}

@keyframes incorrect {
  0% {
    transform: translateX(20px);
  }
  50% {
    transform: translateX(-20px);
  }
  100% {
    transform: translateX(0px);
  }
}

/* Simple CSS3 Fade-in Animation */
@-webkit-keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
@-moz-keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.incorrect {
  animation: incorrect ease-in 1;
}

.fadeIn {
  opacity: 0;
  -webkit-animation: fadeIn ease-in 1;
  -moz-animation: fadeIn ease-in 1;
  animation: fadeIn ease-in 1;

  -webkit-animation-fill-mode: forwards;
  -moz-animation-fill-mode: forwards;
  animation-fill-mode: forwards;

  -webkit-animation-duration: 1s;
  -moz-animation-duration: 1s;
  animation-duration: 1s;
}

.fadeIn.first {
  -webkit-animation-delay: 0.4s;
  -moz-animation-delay: 0.4s;
  animation-delay: 0.4s;
}

/* Simple CSS3 Fade-in Animation */
.underlineHover:after {
  display: block;
  left: 0;
  bottom: -10px;
  width: 0;
  height: 2px;
  background-color: red;
  content: "";
  transition: width 0.2s;
}



.underlineHover:hover {
  color: #0d0d0d;
}

.underlineHover:hover:after {
  width: 100%;
}

.underlineHoverH2:after {
  display: block;
  left: 0;
  bottom: -10px;
  width: 0;
  height: 2px;
  background-color: #2c658e;
  content: "";
  transition: width 0.2s;
}

.underlineHoverH2:hover {
  color: #0d0d0d;
}

.underlineHoverH2:hover:after {
  width: 100%;
}
.suppr {
  color: rgb(197, 38, 38);
}

@media (max-width: 560px) {
  .container {
    width: 100%;
    display: flex;
    flex-direction: column;
    form {
      width: 100%;
      display: flex;
      flex-direction: column;
      input {
        margin-left: 7%;
      }
    }
  }
  .btn {
    max-width: 350px;
    margin-right: auto;
    margin-left: auto;
  }
  .suppr {
  color: rgb(197, 38, 38);
  width: 100%;
}
}

@media (max-width: 481px) {
  h4 {
    display: none;
  }
}
</style>