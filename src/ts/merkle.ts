import { sql } from '@vercel/postgres'
import { createDistribution, type Config } from '@kreskolabs/csv-merkle'

const config = {
	desc: 'fork-claimid-8',
	id: 1001,
	csv: '/csv/mock_dist.csv',
	outputName: 'fork-dist-1',
} as Config

const result = await createDistribution(config, {
	onStart: async ({ self, leafs }) => {
		const del = await sql`DELETE FROM distributions WHERE claimId = ${self.cfg.id}`
		self.log(`${self.cfg.desc}: Deleted ${del.rowCount} existing database rows.`)
	},
	onChunk: async ({ chunk, self, processed, total }) => {
		await sql.query(
			`INSERT INTO distributions (claimDesc, claimId, address, points, proof)
				SELECT '${self.cfg.desc}', ${self.cfg.id}, address, points, proof FROM json_populate_recordset(NULL::distributions, $1)`,
			[JSON.stringify(chunk)],
		)
		self.log(`Inserted ${processed}/${total} leafs..`)
	},
})
