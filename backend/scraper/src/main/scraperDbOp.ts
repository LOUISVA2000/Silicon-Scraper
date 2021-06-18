import {Product} from "../utilities/productsModel";

const { Client, sql, Pool } = require('pg')
const env = require('../../../config')
const scraper = require("./scraper.ts");
const pgp = require('pg-promise')({
    /* initialization options */
    capSQL: true // capitalize all generated SQL
});

const client = {
    host: env.host,
    user: env.user,
    database: env.name,
    password: env.pw,
    port: env.port
}

const db = pgp(
    client
)

const cs = new pgp.helpers.ColumnSet(['brand','model','price','retailer','image','link','availability','details','type'], {table:'gpus'})

const cs_ = new pgp.helpers.ColumnSet(['brand','model','price','retailer','image','link','availability','details', 'type' ], {table:'cpus'})

const getProducts =  async () => {
    await scraper.scrape().then((products: any) => {

        //if  db empty
        // insert(products).then(res => {
        //     console.log(res)
        // })

        //else
        update(products).then(res => {
            console.log(res)
        })

    })

}

getProducts().then(() => {
    console.log("successful")
})

const insert = async (products: any) => {

    await  exeQuery(pgp.helpers.insert(products.gpu, cs))
    await  exeQuery(pgp.helpers.insert(products.cpu, cs_))

}
const exeQuery = async (query:any) =>{
    await db.none(query).then( (err: any) => {
        if(err){
            console.log(err)
        }else{
            console.log(200, " ok")
        }
    })
}

getProducts().then(r => {
    console.log("getProducts")
})



const update = async (products: any) => {

    await  queryProducts("gpu", products.gpu)
    await  queryProducts("cpu", products.cpu)

}
/**
 * Ths function get all products from the data base given a product type
 * @param type
 * @returns []
 */
const queryProducts = async (table:string, products:Product[])=>{
    await db.any(`SELECT * FROM $1`,table).then( (result:any)=>{
         updateProducts(result, products, table)
    })
}

/**
 * this function updates the availability or rent
 * @param table
 * @param column
 * @param value
 * @param id
 */
const updateDetails = async (table:any, column:any, value:any, id:any)=>{
    await db.none('UPDATE ${table:name} ${column:name}=${value:name} WHERE id=${id:name}', {
        table:table,
        column:column,
        value:value,
        id:id
    });
}


/**
 * The function get all products from the data base given a product type
 * This function will take in a list of products, query the database and compare the incoming data with
 * the data queried, if any changes are found the database will be updated
 *
 * @returns void
 * @param products
 */
const updateProducts = async (results:any, products:Product[], table:string)=>{
    for( const rkey in results) {
        for (const pkey in products) {
            if (products[pkey].model === results[rkey].model && products[pkey].brand === results[rkey].brand && products[pkey].retailer === results[rkey].retailer) {
                let avail = false;
                //Update the availability and/or price if it changed
                if(!(products[pkey].availability === results[rkey].availability)){
                    avail=true;
                    //call update
                    await updateDetails(table, "availability", products[pkey].availability, results[rkey].id)

                }else if (!(products[pkey].price === results[rkey].price)){
                    //call update
                    await updateDetails(table, "price", products[pkey].price, results[rkey].id)

                }
                if(!avail){
                    //test the timestamp
                    let currentDate = results[rkey].details.productDetails[0].datetime.split('-')[1]
                    let newDate = products[pkey].details.productDetails[0].datetime.split('-')[1]
                    let currDay = results[rkey].details.productDetails[0].datetime.split('-')[2]
                    let newDay = products[pkey].details.productDetails[0].datetime.split('-')[2]
                    let timeInDb = (Number(newDate) - Number(currentDate))*3+ Number(currDay) + Number(newDay)
                    if(timeInDb >= 90){
                        //This item is stale and had its availability has not been updated, it must be removed from the database
                        await deleteProduct(results[rkey].id, table).then((error:any)=>{
                            if(error){
                                console.log(error)
                            }else{
                                console.log("Successful")
                            }
                        })

                    }

                }

            }
        }
    }
}



/**
 * if the timestamp of an item
 * that has been unavailable for over 3 months we would remove that item from the data base
 *
 * @param id
 * @returns void
 */
const deleteProduct = async (id:any, table:any) => {
    await db.none('DELETE FROM ${table:name} WHERE id=${id:name}', {
        table:table,
        id:id
    })
}