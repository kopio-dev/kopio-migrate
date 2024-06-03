import { StandardMerkleTree } from '@openzeppelin/merkle-tree'

export function stringify(tree: [string, any][]) {
  return JSON.stringify(
    tree.map(([address, amount]) => [address, amount.toString()]),
    null,
    2,
  )
}

export function logTree<T extends any[]>(tree: StandardMerkleTree<T>) {
  console.log('***************************')
  console.log('Leafs: ')
  console.log('Merkle Tree: ')
  console.log(tree.dump())
  console.log('---------------------------')
  console.log('root', tree.root)
  console.log('***************************')
}
