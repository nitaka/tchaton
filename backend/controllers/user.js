const { pool } = require('../config/db');
const bcrypt = require("bcrypt");
const jwt = require('jsonwebtoken');
const dotenv = require("dotenv").config();
const fs = require("fs");


exports.delete = (req, res, next) => {
    if (req.body.password) {
        let sql = `SELECT * FROM user WHERE id=?`;
        pool.execute(sql, [req.params.id], function (err, result) {
            let user = result[0];
            bcrypt.compare(req.body.password, user.password)
            .then(valid => {
                if (!valid) {
                    return res.status(401).json({ error: " Mot de passe incorrect !" });
                } else {
                    bcrypt.hash(req.body.password, 10)
                    .then(hash => {
                        let sql = `DELETE FROM user WHERE id=?`;
                        pool.execute(sql, [req.params.id], function (err, result) {
                            if (err) throw err;
                            console.log(result);
                            res.status(200).json({ message: `Compte numéro ${req.params.id} supprimé` });
                        });
                    })
                    .catch(error => res.status(500).json({ error }));
                }
            })
            .catch(error => res.status(500).json({ message: "Erreur authentification" }));
        })
    }
}

exports.signup = (req, res, next) => {
    // crée compte
    let sql = `SELECT * FROM user WHERE email=?`;
    pool.execute(sql, [req.body.email], function (err, result) {
        let user = result[0];
        if (!user) {
            bcrypt.hash(req.body.password, 10)
                .then(hash => {
                    const image = `${req.protocol}://${req.get('host')}/images/profil/imgProfil.png`;
                    const user = {
                        nom: req.body.nom,
                        prenom: req.body.prenom,
                        email: req.body.email,
                        password: hash,
                        imageUrl: image,
                    }
                    let sql = `INSERT INTO user (nom, prenom, email, password, imgProfil) VALUES (?,?,?,?,?)`;
                    pool.execute(sql, [user.nom, user.prenom, user.email, user.password, user.imageUrl], function (err, result) {
                        if (err) throw err;
                        res.status(201).json({ message: `Utilisateur ${user.prenom} ajouté` });
                    })
                })
                .catch(error => res.status(500).json({ error }));
        } else {
            res.status(401).json({ message: "Email existe déja" })
        }
    })

};

exports.login = (req, res, next) => {
    // Connexion au site
    let sql = `SELECT * FROM user WHERE email=?`;
    pool.execute(sql, [req.body.email], function (err, result) {
        let user = result[0];
        if (!user) return res.status(401).json({ error: "Email incorrect" });
        bcrypt.compare(req.body.password, user.password)
        .then(valid => {
            if (!valid) {
                return res.status(401).json({ error: " Mot de passe incorrect !" })
            }
            console.log("utilisateur connecté");
            res.status(200).json({
                userId: user.id,
                token: jwt.sign(
                    { userId: user.id },
                    process.env.SECRET_TOKEN_KEY,
                    { expiresIn: "24h" },
                ),
            })
        })
        .catch(error => res.status(500).json({ message: "Erreur authentification" }));
    })
};

exports.getOne = (req, res, next) => {
    // recupére les données par ID
    let sql = `SELECT * FROM user WHERE user.id=${req.body.userId};`;
    pool.execute(sql, function (err, result) {
        if (err) res.status(400).json({ err });
        res.status(200).json(result)
    });
}

exports.getAs = (req, res, next) => {
    // Récupére toute les données
    let sql = `SELECT * FROM user WHERE nom LIKE '%${req.body.nom}%' OR prenom LIKE '%${req.body.nom}%' LIMIT 12;`;
    pool.execute(sql, [req.body.nom], function (err, result) {
        if (err) res.status(400).json({ err });
        res.status(200).json(result)
    });
}

exports.modifPassword = (req, res, next) => {
    if (req.body.password) {
        let sql = `SELECT * FROM user WHERE id=?`;
        pool.execute(sql, [req.params.id], function (err, result) {
            let user = result[0];
            bcrypt.compare(req.body.oldPassword, user.password)
            .then(valid => {
                if (!valid) {
                    return res.status(401).json({ error: " Mot de passe incorrect !" });
                } else {
                    bcrypt.hash(req.body.password, 10)
                    .then(hash => {
                        let sql2 = `UPDATE user SET password= ? WHERE id = ?;`;
                        pool.execute(sql2, [hash, req.params.id], function (err, result) {
                            if (err) throw err;
                            res.status(200).json({ message: "Mot de passe modifié" })
                        });
                    })
                    .catch(error => res.status(500).json({ error }));
                }
            })
            .catch(error => res.status(400).json({ message: "Erreur authentification" }));
        })
    }
}

exports.modifAccount = (req, res, next) => {
    if (req.body.nom != "") {
        let sql2 = `UPDATE user SET nom= ? WHERE id = ?`;
        pool.execute(sql2, [req.body.nom, req.params.id], function (err, result) {
            if (err) throw err;
        });
    }
    if (req.body.prenom != "") {
        let sql2 = `UPDATE user SET prenom= ? WHERE id = ?;`;
        pool.execute(sql2, [req.body.prenom, req.params.id], function (err, result) {
            if (err) throw err;
        });
    }
    res.status(200).json({ message: "Information user update" });
}

exports.modifImg = (req, res, next) => {
    // Changer image du profil
    if (req.file) {
        let sql = `SELECT * FROM user WHERE id = ?`;
        pool.execute(sql, [req.params.id], function (err, result) {
            if (err) res.status(400).json({ err });
            if (!result[0]) res.status(400).json({ message: "Aucun id ne correspond dans la table" });
            else {
                // Supp image images/profil
                if (result[0].imgProfil != "http://localhost:3000/images/profil/imgProfil.png") {
                    const name = result[0].imgProfil.split('/images/profil/')[1];
                    fs.unlink(`images/profil/${name}`, () => {
                        if (err) console.log(err);
                        else console.log('Image modifiée !');
                    })
                }
                // Recup les infos de la page
                let image = (req.file) ? `${req.protocol}://${req.get('host')}/images/profil/${req.file.filename}` : "";
                // Maj bdd
                let sql2 = `UPDATE user SET imgProfil = ? WHERE id = ?`;
                pool.execute(sql2, [image, req.params.id], function (err, result) {
                    if (err) throw err;
                    res.status(201).json({ message: `Photo user udpate` });
                });
            }
        });
    }
};
